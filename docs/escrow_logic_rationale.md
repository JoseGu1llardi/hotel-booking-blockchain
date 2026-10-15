# Escrow Logic and Security Rationale (Commit 5)

## 1. Introduction

This document explains the implementation of the escrow mechanism in the
`HotelBooking` smart contract. It details how funds are securely held and
released to either the hotel or the guest, and the security patterns used
to prevent common blockchain attacks.

## 2. The Escrow Mechanism

### What it is:

An escrow is a financial arrangement where a third party (the smart contract)
holds funds until a specific condition is met. In our system, the contract
holds the guest's payment until the hotel confirms the check-in.

### Why we use it:

This eliminates the need for a trusted intermediary like a bank or an OTA
(Online Travel Agency). The code enforces the rules: if the hotel confirms
check-in, they get paid. If the guest cancels beforehand, they get a 100%
refund. This creates a "trustless" environment (Nakamoto, 2008).

## 3. Security Pattern: Checks-Effects-Interactions

### What it is:

In both `confirmCheckIn` and `cancelBooking`, we follow a strict order of
operations:

1. **Checks:** Validate all conditions using `require()` (e.g., is the sender
   the hotel? is the booking active?).
2. **Effects:** Update the contract's state variables (e.g., set
   `isActive = false`).
3. **Interactions:** Transfer the ETH to the user.

### Why we use it:

This is the most critical security pattern in Solidity. If we transferred
the ETH _before_ updating the state, a malicious attacker could use a
"Reentrancy Attack" to call the function repeatedly and drain all the funds
from the contract before the state was updated (Atzei, Bartoletti and Cimoli,
2017). By updating the state first, we prevent this vulnerability.

## 4. Using `.call{value:}` instead of `.transfer()`

### What it is:

To send ETH, we use `(bool success, ) = payable(address).call{value: amount}("");`
instead of the older `address.transfer(amount)` method.

### Why we use it:

The `.transfer()` method limits the gas forwarded to the receiver to 2300 units.
If the receiver is a smart contract (like a hotel's treasury contract) that
requires more gas to process the incoming funds, the transaction would fail.
Using `.call{value:}` forwards all available gas, making the system more robust
and compatible with modern Ethereum standards (Ethereum Foundation, 2024).
We still ensure safety by checking `require(success, "...")` immediately after.

## References

- Atzei, R., Bartoletti, M. and Cimoli, T., 2017. A survey of attacks on Ethereum smart contracts. In: _International Conference on Principles of Security and Trust_, pp.161-186. Cham: Springer.
- Ethereum Foundation, 2024. _Solidity documentation_. [online] Available at: https://docs.soliditylang.org/ [Accessed 10 October 2026].
- Nakamoto, S., 2008. _Bitcoin: A peer-to-peer electronic cash system_. [online] Available at: https://bitcoin.org/bitcoin.pdf [Accessed 10 October 2026].
