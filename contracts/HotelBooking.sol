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
}