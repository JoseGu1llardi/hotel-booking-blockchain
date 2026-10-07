# Use Case Analysis

## Primary Actors

1. **Guest (Sender):** Books rooms, makes payments, may cancel
2. **Hotel (Receiver):** Lists rooms, confirms check-ins, receives payments
3. **Smart Contract (Middle Layer):** Holds funds, enforces rules, releases payments

This three-party model reflects the decentralized architecture described
by Wood (2014) in the Ethereum Yellow Paper, where the blockchain acts as
a deterministic state machine mediating interactions between participants.

## Use Case Diagram

(To be added as UML diagram in poster)

## Detailed Use Cases

### UC1: Create Booking

- **Actor:** Guest
- **Precondition:** Guest has MetaMask wallet with ETH
- **Flow:**
  1. Guest selects hotel and room
  2. Guest calls `createBooking(hotelAddress, bookingDetails)` with ETH
  3. Smart contract generates SHA-256 hash of booking details (NIST, 2015)
  4. Funds locked in contract, booking marked as active
- **Postcondition:** Booking exists on-chain, funds in escrow
- **Security:** Transaction signed via ECDSA (Johnson, Menezes and Vanstone, 2001)

### UC2: Confirm Check-In

- **Actor:** Hotel
- **Precondition:** Active booking exists
- **Flow:**
  1. Hotel calls `confirmCheckIn(bookingId)`
  2. Contract verifies caller is the registered hotel
  3. Funds transferred to hotel address
  4. Booking marked as checked-in
- **Postcondition:** Hotel receives payment, booking finalized
- **Pattern:** Uses checks-effects-interactions to prevent reentrancy (Atzei, Bartoletti and Cimoli, 2017)

### UC3: Cancel Booking

- **Actor:** Guest
- **Precondition:** Booking is active and not checked-in
- **Flow:**
  1. Guest calls `cancelBooking(bookingId)`
  2. Contract verifies caller is the guest
  3. Funds refunded to guest
  4. Booking marked as inactive
- **Postcondition:** Guest receives full refund

### UC4: Unauthorized Access Attempt

- **Actor:** Malicious third party
- **Flow:**
  1. Attacker calls `confirmCheckIn` on someone else's booking
  2. Contract rejects with "Only the hotel can confirm check-in"
- **Postcondition:** No state change, transaction reverted

## Security Considerations

### Authentication via ECDSA

Every transaction is signed using the Elliptic Curve Digital Signature
Algorithm (ECDSA) with the secp256k1 curve (Certicom Research, 2010).
This provides:

- **Authentication:** Proves sender identity
- **Non-repudiation:** Sender cannot deny the transaction
- **Integrity:** Transaction cannot be altered in transit

### Data Integrity via SHA-256

Booking details are hashed using SHA-256 (NIST, 2015), providing:

- **Collision resistance:** Computationally infeasible to forge
- **Determinism:** Same input always produces same hash
- **Avalanche effect:** Small changes produce completely different hashes

### Smart Contract Security

The implementation follows best practices to prevent common vulnerabilities
(Atzei, Bartoletti and Cimoli, 2017):

- Checks-effects-interactions pattern prevents reentrancy
- Input validation on all public functions
- State changes before external calls
- Comprehensive require() statements

## References

- Atzei, R., Bartoletti, M. and Cimoli, T., 2017. A survey of attacks on Ethereum smart contracts. _International Conference on Principles of Security and Trust_, pp.161-186.
- Certicom Research, 2010. _SEC 2: Recommended elliptic curve domain parameters_.
- Johnson, D., Menezes, A. and Vanstone, S., 2001. The elliptic curve digital signature algorithm (ECDSA). _International Journal of Information Security_, 1(1), pp.36-63.
- NIST, 2015. _FIPS PUB 180-4: Secure Hash Standard_.
- Wood, G., 2014. _Ethereum: A secure decentralised generalised transaction ledger_.
