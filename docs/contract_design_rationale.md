# Smart Contract Design Rationale

## 1. Introduction

This document explains the architectural decisions behind the `HotelBooking`
smart contract. It details what each component does and why it was designed
this way. The primary goal is to build a secure, transparent, and fully
decentralized (trustless) escrow system for hotel reservations.

## 2. Struct Definition

### What it is:

A `struct` in Solidity is a custom data type that groups related variables
together. We created a `Booking` struct to store all details of a single
reservation in one place.

### Why we use it:

Using a struct keeps the code clean and organized (Antonopoulos and Wood, 2019).
Instead of managing multiple disconnected arrays for guests, hotels, and
amounts, the struct ensures that all data related to a specific booking is
retrieved together. It also includes a `bookingHash` field, which will later
store a SHA-256 hash to guarantee data integrity.

## 3. State Variables

### What they are:

State variables are permanently stored on the blockchain.

- `bookings`: A mapping that links a unique numeric ID to a `Booking` struct.
- `bookingCounter`: A counter that increments with every new booking.

### Why we use them:

Mappings are the most gas-efficient way to store and retrieve data in Solidity
(Ethereum Foundation, 2024). The `bookingCounter` ensures that every booking
receives a unique, sequential ID (1, 2, 3...), preventing data overwrites and
making it easy for users to query their specific reservation.

## 4. Events

### What they are:

Events are logs emitted by the smart contract and stored on the blockchain.
We defined three events: `BookingCreated`, `CheckInCompleted`, and
`BookingCancelled`.

### Why we use them:

Smart contracts cannot directly send data to a front-end user interface after
a transaction. Events solve this by allowing external applications (like a
website or a monitoring tool) to "listen" for specific actions (Ethereum
Foundation, 2024). We used the `indexed` keyword for the booking ID and
addresses to make filtering and searching these logs faster and cheaper.

## 5. Decentralization: The Absence of an "Owner"

### What it is:

Unlike many standard smart contracts, this contract **does not** include an
`owner` variable, an `onlyOwner` modifier, or an `emergencyWithdraw` function.

### Why we removed it:

In centralized systems, an administrator can freeze or withdraw user funds.
However, a truly trustless blockchain escrow must rely solely on code, not
human trust. By intentionally removing admin privileges over the funds, we
ensure that:

1. The hotel receives payment _only_ when they confirm the check-in.
2. The guest receives a full refund _only_ if they cancel before check-in.
3. No third party (not even the contract creator) can intercept, freeze, or
   steal the funds.
   This design strictly aligns with the core "trustless" principle of blockchain
   technology (Nakamoto, 2008) and eliminates the risk of a malicious
   intermediary.

## 6. Aligned Cancellation Policy

To ensure consistency between the business model and the technical
implementation, the cancellation rule is strictly defined: **The guest
receives a 100% refund if they cancel the booking before the hotel confirms
the check-in.** There are no hidden fees or arbitrary penalties. This
transparency is enforced automatically by the smart contract logic.

## 7. View Functions

### What they are:

`getBooking()` is a view function. It reads data from the blockchain without
altering the state.

### Why we use them:

View functions do not cost gas (transaction fees). We use this function to
allow users and front-end applications to check the details, status, and
cryptographic hash of any booking for free (Ethereum Foundation, 2024).

## References

- Antonopoulos, A.M. and Wood, G., 2019. _Mastering Ethereum: Building smart contracts and DApps_. Sebastopol: O'Reilly Media.
- Ethereum Foundation, 2024. _Solidity documentation_. [online] Available at: https://docs.soliditylang.org/ [Accessed 10 October 2026].
- Nakamoto, S., 2008. _Bitcoin: A peer-to-peer electronic cash system_. [online] Available at: https://bitcoin.org/bitcoin.pdf [Accessed 10 October 2026].
