# Deployment and Testing Guide (Commit 6)

## 1. Introduction

This document outlines the step-by-step procedure for deploying and testing
the `HotelBooking` smart contract. The testing was conducted using the
Remix IDE and the built-in Remix VM (London) to simulate a local Ethereum
blockchain environment (Ethereum Foundation, 2024).

## 2. Prerequisites

- Web browser (Chrome, Firefox, or Edge)
- Access to Remix IDE: https://remix.ethereum.org
- The `HotelBooking.sol` file compiled successfully with Solidity ^0.8.19

## 3. Step-by-Step Testing Procedure

### Step 1: Compilation and Deployment

1. Open Remix IDE and ensure `HotelBooking.sol` is the active file.
2. Navigate to the "Solidity Compiler" tab (icon on the left) and click
   "Compile HotelBooking.sol". Ensure no errors or warnings are present.
3. Navigate to the "Deploy & Run Transactions" tab.
4. Set the "Environment" to "Remix VM (London)".
5. Ensure "Account 1" (0x5B3...8D) is selected. This account will act as
   the **Guest**.
6. Click the "Deploy" button.
7. **Screenshot 1:** Capture the deployment transaction in the Remix console,
   showing the contract address and the "Deploy" button click.

### Step 2: Create a Booking (Guest Action)

1. In the "Deployed Contracts" section, expand the `HotelBooking` contract.
2. Locate the `createBooking` function.
3. In the "hotel" field, paste the address of **Account 2** (0xAb8...4C),
   which will act as the Hotel.
4. In the "bookingDetails" field, enter a test string, e.g.,
   "Room 101, 2026-11-15 to 2026-11-18".
5. In the "Value" field (above the Deploy button), enter `1` and ensure
   the dropdown is set to "Ether" (this simulates a 1 ETH payment).
6. Click "transact" and confirm the transaction in the simulated MetaMask
   prompt.
7. **Screenshot 2:** Capture the Remix console showing the successful
   `createBooking` transaction, the gas used, and the emitted
   `BookingCreated` event with the generated SHA-256 hash.

### Step 3: Verify Booking Details

1. Locate the `getBooking` function in the deployed contract.
2. Enter `1` in the `uint256 _bookingId` field and click "getBooking".
3. **Screenshot 3:** Capture the decoded output showing the guest address,
   hotel address, amount (1000000000000000000 wei), and `isActive: true`.

### Step 4: Security Test - Unauthorized Access Attempt

1. Change the active "Account" in the top dropdown to **Account 3**
   (0x147...2A), simulating a malicious third party.
2. Locate the `confirmCheckIn` function and enter `1` for the `_bookingId`.
3. Click "transact".
4. **Screenshot 4:** Capture the Remix console showing the red error message:
   "transact to HotelBooking.confirmCheckIn errored: ... Only the hotel can
   confirm check-in". This proves the access control is working.

### Step 5: Confirm Check-In (Hotel Action)

1. Change the active "Account" back to **Account 2** (the Hotel).
2. Note the ETH balance of Account 2 in the top dropdown (e.g., 100 ETH).
3. Locate the `confirmCheckIn` function, enter `1` for the `_bookingId`,
   and click "transact".
4. **Screenshot 5:** Capture the Remix console showing the successful
   transaction, the emitted `CheckInCompleted` event, and the updated
   balance of Account 2 (which should now be ~101 ETH).

### Step 6: Test Cancellation (Guest Action)

1. Change the active "Account" back to **Account 1** (the Guest).
2. Call `createBooking` again with Account 2 as the hotel, new details
   ("Room 102"), and 1 ETH value. Note the new booking ID (e.g., `2`).
3. Locate the `cancelBooking` function, enter `2` for the `_bookingId`,
   and click "transact".
4. **Screenshot 6:** Capture the Remix console showing the successful
   cancellation transaction, the emitted `BookingCancelled` event, and
   the refunded ETH balance of Account 1.

## 4. Conclusion

The testing procedure successfully demonstrated all core functionalities:
deployment, booking creation with SHA-256 hashing, unauthorized access
prevention, successful escrow release to the hotel, and guest refund
upon cancellation.

## References

- Ethereum Foundation, 2024. _Remix IDE documentation_. [online] Available at: https://remix-ide.readthedocs.io/ [Accessed 17 October 2026].
