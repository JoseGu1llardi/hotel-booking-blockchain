// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

/**
 * @title HotelBooking
 * @dev Fully decentralized hotel booking system acting as a trustless escrow.
 * @author Jose Wellington
 * @notice This contract manages bookings between guests and hotels without 
 *         any central authority or admin privileges over user funds.
 */
contract HotelBooking {

    // ==========================================
    // 1. STRUCT DEFINITION
    // ==========================================
    
    /**
     * @dev Represents a single hotel booking.
     * @param guest The address of the person making the booking (Sender).
     * @param hotel The address of the hotel receiving the booking (Receiver).
     * @param amount The payment amount in wei held in escrow.
     * @param timestamp The Unix timestamp when the booking was created.
     * @param bookingHash SHA-256 hash of booking details (for data integrity).
     * @param isActive True if the booking is valid and not cancelled.
     * @param isCheckedIn True if the hotel has confirmed the guest's check-in.
     */
    struct Booking {
        address guest;
        address hotel;
        uint256 amount;
        uint256 timestamp;
        bytes32 bookingHash;
        bool isActive;
        bool isCheckedIn;
    }

    // ==========================================
    // 2. STATE VARIABLES
    // ==========================================
    
    /// @dev Mapping to store all bookings using a unique ID as the key.
    mapping(uint256 => Booking) public bookings;
    
    /// @dev Counter to generate unique, sequential booking IDs.
    uint256 public bookingCounter;

    // ==========================================
    // 3. EVENTS
    // ==========================================
    
    /**
     * @dev Emitted when a new booking is successfully created.
     * @param bookingId The unique ID of the booking.
     * @param guest The guest's address.
     * @param hotel The hotel's address.
     * @param amount The amount paid.
     */
    event BookingCreated(
        uint256 indexed bookingId, 
        address indexed guest, 
        address indexed hotel, 
        uint256 amount
    );
    
    /**
     * @dev Emitted when the hotel confirms a guest's check-in.
     * @param bookingId The unique ID of the booking.
     * @param hotel The hotel's address.
     * @param amount The amount released to the hotel.
     */
    event CheckInCompleted(
        uint256 indexed bookingId, 
        address indexed hotel, 
        uint256 amount
    );
    
    /**
     * @dev Emitted when a guest cancels a booking.
     * @param bookingId The unique ID of the booking.
     * @param guest The guest's address.
     * @param amount The amount refunded to the guest.
     */
    event BookingCancelled(
        uint256 indexed bookingId, 
        address indexed guest, 
        uint256 amount
    );

    // ==========================================
    // 4. VIEW FUNCTIONS
    // ==========================================
    
    /**
     * @dev Retrieves all details of a specific booking.
     * @param _bookingId The unique ID of the booking to retrieve.
     * @return guest The guest address.
     * @return hotel The hotel address.
     * @return amount The booking amount in wei.
     * @return timestamp The creation timestamp.
     * @return bookingHash The SHA-256 hash of the booking details.
     * @return isActive The active status of the booking.
     * @return isCheckedIn The check-in status of the booking.
     */
    function getBooking(uint256 _bookingId) 
        public 
        view 
        returns (
            address guest,
            address hotel,
            uint256 amount,
            uint256 timestamp,
            bytes32 bookingHash,
            bool isActive,
            bool isCheckedIn
        ) 
    {
        Booking storage booking = bookings[_bookingId];
        return (
            booking.guest,
            booking.hotel,
            booking.amount,
            booking.timestamp,
            booking.bookingHash,
            booking.isActive,
            booking.isCheckedIn
        );
    }

        // ==========================================
    // 6. CORE FUNCTIONS: CREATE BOOKING
    // ==========================================
    
    /**
     * @dev Creates a new booking between a guest and a hotel.
     * @param _hotel The address of the hotel (Receiver).
     * @param _bookingDetails A string containing booking details (e.g., "Room 101, 2026-11-15").
     * @notice The guest must send ETH with this transaction (msg.value > 0).
     * @notice Booking details are hashed using SHA-256 to guarantee data integrity.
     */
    function createBooking(address _hotel, string memory _bookingDetails) 
        public 
        payable 
    {
        // 1. CHECKS: Validate inputs to prevent errors and save gas
        require(_hotel != address(0), "Invalid hotel address");
        require(_hotel != msg.sender, "Guest and hotel cannot be the same address");
        require(msg.value > 0, "Payment amount must be greater than zero");
        
        // 2. DATA INTEGRITY: Generate SHA-256 hash of the booking details
        // We pack the details, sender, receiver, amount, and timestamp to ensure 
        // this specific booking is unique and cannot be tampered with.
        bytes32 hashDetails = sha256(
            abi.encodePacked(
                _bookingDetails, 
                msg.sender, 
                _hotel, 
                msg.value, 
                block.timestamp
            )
        );
        
        // 3. EFFECTS: Update the state
        bookingCounter++;
        
        bookings[bookingCounter] = Booking({
            guest: msg.sender,           // Authenticated via ECDSA (MetaMask signature)
            hotel: _hotel,
            amount: msg.value,
            timestamp: block.timestamp,
            bookingHash: hashDetails,    // SHA-256 ensures integrity
            isActive: true,
            isCheckedIn: false
        });
        
        // 4. INTERACTIONS: Emit event for off-chain tracking
        emit BookingCreated(
            bookingCounter, 
            msg.sender, 
            _hotel, 
            msg.value
        );
    }

    // ==========================================
    // 7. ESCROW LOGIC: CONFIRM CHECK-IN
    // ==========================================
    
    /**
     * @dev Allows the hotel to confirm a guest's check-in and receive funds.
     * @param _bookingId The unique ID of the booking to confirm.
     * @notice Only the registered hotel address can call this function.
     * @notice Funds are released immediately upon successful check-in.
     */
    function confirmCheckIn(uint256 _bookingId) public {
        Booking storage booking = bookings[_bookingId];

        // 1. CHECKS: Validate conditions
        require(_bookingId > 0 && _bookingId <= bookingCounter, "Invalid booking ID");
        require(msg.sender == booking.hotel, "Only the hotel can confirm check-in");
        require(booking.isActive, "Booking is not active");
        require(!booking.isCheckedIn, "Check-in already confirmed");

        uint256 amountToRelease = booking.amount;

        // 2. EFFECTS: Update state BEFORE transferring funds (Prevents Reentrancy)
        booking.isActive = false;
        booking.isCheckedIn = true;

        // 3. INTERACTIONS: Transfer funds to the hotel
        (bool success, ) = payable(booking.hotel).call{value: amountToRelease}("");
        require(success, "ETH transfer to hotel failed");

        emit CheckInCompleted(_bookingId, booking.hotel, amountToRelease);
    }

    // ==========================================
    // 8. ESCROW LOGIC: CANCEL BOOKING
    // ==========================================
    
    /**
     * @dev Allows the guest to cancel a booking and receive a full refund.
     * @param _bookingId The unique ID of the booking to cancel.
     * @notice Only the guest who made the booking can cancel it.
     * @notice Cancellation is only allowed before check-in is confirmed.
     */
    function cancelBooking(uint256 _bookingId) public {
        Booking storage booking = bookings[_bookingId];

        // 1. CHECKS
        require(_bookingId > 0 && _bookingId <= bookingCounter, "Invalid booking ID");
        require(msg.sender == booking.guest, "Only the guest can cancel");
        require(booking.isActive, "Booking is not active");
        require(!booking.isCheckedIn, "Cannot cancel after check-in");

        uint256 amountToRefund = booking.amount;

        // 2. EFFECTS: Update state BEFORE refunding
        booking.isActive = false;

        // 3. INTERACTIONS: Refund the guest
        (bool success, ) = payable(booking.guest).call{value: amountToRefund}("");
        require(success, "ETH refund to guest failed");

        emit BookingCancelled(_bookingId, booking.guest, amountToRefund);
    }
}