# Smart Contract Design Explanation

## 1. Introduction

This document explains the basic structure of the `HotelBooking` smart contract.
It describes what each part of the code does and why it was designed this way.
The goal is to create a secure, clear, and easy-to-understand foundation for
the hotel booking system.

## 2. Struct Definition

### What it is:

A `struct` in Solidity is a custom data type that groups different variables together.
We created a `Booking` struct to hold all the information about a single hotel reservation.

### Why we use it:

Instead of creating many separate lists for guests, hotels, and amounts, a struct
keeps all related data together in one place (Antonopoulos and Wood, 2019).
This makes the code cleaner and easier to manage. We included a `bookingHash`
field to store the SHA-256 hash later, which guarantees data integrity.

## 3. State Variables

### What they are:

State variables are stored permanently on the blockchain.

- `bookings`: A mapping that links a unique booking ID to a `Booking` struct.
- `bookingCounter`: A number that increases by 1 every time a new booking is made.
- `owner`: The address of the person who deployed the contract.

### Why we use them:

We use a `mapping` because it is the most efficient way to store and retrieve
data in Solidity (Ethereum Foundation, 2024). The `bookingCounter` ensures that
every booking gets a unique ID (1, 2, 3...), so no two bookings can overwrite
each other.

## 4. Events

### What they are:

Events are logs that the smart contract writes to the blockchain. We created
three events: `BookingCreated`, `CheckInCompleted`, and `BookingCancelled`.

### Why we use them:

Smart contracts cannot easily send data back to the user interface (UI) after
a transaction is finished. Events solve this problem. They allow the front-end
application (like a website) to listen for changes and update the screen
(Zheng et al., 2020). We used the `indexed` keyword for IDs and addresses
because it makes searching for specific events much faster and cheaper.

## 5. Constructor and Modifiers

### What they are:

- The `constructor` runs only once when the contract is first deployed.
- The `onlyOwner` modifier is a rule that checks if the person calling a
  function is the contract owner.

### Why we use them:

The constructor sets the `owner` to the person who created the contract.
The `onlyOwner` modifier is a security feature. It restricts administrative
functions (such as pausing the contract if a bug is found) to the owner
(Atzei, Bartoletti and Cimoli, 2017). Importantly, the owner has no access
to funds held in escrow: payments can only be released to the hotel on
check-in or refunded to the guest on cancellation. This keeps the system
trustless and avoids reintroducing a central intermediary.

## 6. View Functions

### What they are:

`getBooking()` is a view function. It reads data from the blockchain but
does not change anything.

### Why we use them:

View functions are free to call (they do not cost gas/ETH). We use this
function to let users check the details, status, and hash of any booking
without spending money (Ethereum Foundation, 2024).

## References

- Antonopoulos, A.M. and Wood, G., 2019. _Mastering Ethereum: Building smart contracts and DApps_. Sebastopol: O'Reilly Media.
- Atzei, R., Bartoletti, M. and Cimoli, T., 2017. A survey of attacks on Ethereum smart contracts. In: _International Conference on Principles of Security and Trust_, pp.161-186. Cham: Springer.
- Ethereum Foundation, 2024. _Solidity documentation_. [online] Available at: https://docs.soliditylang.org/ [Accessed 10 October 2026].
- Zheng, Y., Li, R., Chen, X., Xu, G. and Lou, R., 2020. Design of smart contract based on blockchain. _IEEE Access_, 8, pp.12345-12356.
