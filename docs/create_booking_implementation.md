# Create Booking Implementation Rationale (Commit 4)

## 1. Introduction

This document explains the implementation of the `createBooking` function.
It details how the smart contract securely accepts payments, validates inputs,
and guarantees data integrity using cryptographic hashing.

## 2. The `payable` Modifier and `msg.value`

### What it is:

The `payable` keyword allows the function to receive Ethereum (ETH).
`msg.value` represents the amount of ETH sent by the user (the guest)
in this specific transaction.

### Why we use it:

For the smart contract to act as an escrow (middle layer), it must be able
to hold the guest's funds. The `payable` modifier enables this capability
(Ethereum Foundation, 2024).

## 3. Input Validation (The "Checks" Pattern)

### What it is:

Before executing any logic, the function uses `require()` statements to
validate the inputs:

- The hotel address cannot be the zero address (`address(0)`).
- The guest and hotel cannot be the same address.
- The payment amount (`msg.value`) must be greater than zero.

### Why we use it:

This follows the "fail-fast" principle. If the inputs are invalid, the
transaction reverts immediately. This prevents logical errors and saves
the user from paying unnecessary gas fees for a failed transaction
(Antonopoulos and Wood, 2019).

## 4. Data Integrity via SHA-256 Hashing

### What it is:

We use the built-in Solidity `sha256()` function combined with
`abi.encodePacked()` to generate a unique cryptographic hash of the
booking details.

### Why we use it:

Blockchain is transparent, but data can still be misrepresented off-chain.
By hashing the `_bookingDetails` along with the `msg.sender`, `_hotel`,
`msg.value`, and `block.timestamp`, we create a unique digital fingerprint.
If any detail is altered later, the hash will not match. SHA-256 is chosen
because it is the industry standard for collision resistance and data
integrity, as defined by the National Institute of Standards and Technology
(NIST, 2015).

## 5. State Updates and Event Emission

### What it is:

After validation and hashing, the `bookingCounter` is incremented, and the
new `Booking` struct is saved to the `bookings` mapping. Finally, the
`BookingCreated` event is emitted.

### Why we use it:

Updating the state _after_ all checks ensures the contract remains in a
valid state. Emitting the event allows front-end applications (like a
website) to instantly notify the user that their booking was successful
without having to constantly poll the blockchain (Ethereum Foundation, 2024).

## References

- Antonopoulos, A.M. and Wood, G., 2019. _Mastering Ethereum: Building smart contracts and DApps_. Sebastopol: O'Reilly Media.
- Ethereum Foundation, 2024. _Solidity documentation_. [online] Available at: https://docs.soliditylang.org/ [Accessed 10 October 2026].
- NIST, 2015. _FIPS PUB 180-4: Secure Hash Standard (SHS)_. Gaithersburg, MD: U.S. Department of Commerce. [online] Available at: https://nvlpubs.nist.gov/nistpubs/FIPS/NIST.FIPS.180-4.pdf [Accessed 10 October 2026].
