# Business Model Analysis: Decentralized Hotel Booking

## 1. Current System Pain Points

The traditional hotel booking market is dominated by Online Travel Agencies
(OTAs) such as Booking.com, Expedia, and Airbnb. These platforms exhibit
several structural problems that negatively impact both consumers and hotels.

### 1.1 Excessive Commission Fees

OTAs charge between 15-25% commission per booking (Statista, 2024;
Phocuswright, 2023). This cost is ultimately passed to consumers through
inflated room rates, reducing competitiveness of independent hotels
(European Commission, 2017).

### 1.2 Fund Retention and Cash Flow Issues

OTAs typically hold guest payments for 7-30 days before releasing funds to
hotels, creating cash flow problems for small and medium-sized hotels.
This practice contradicts the principles of efficient digital transactions
(Tapscott and Tapscott, 2016).

### 1.3 Opaque Cancellation Policies

Cancellation rules are often unclear, inconsistently enforced, and subject
to unilateral changes by the platform, creating information asymmetry
between OTAs and consumers (Önder and Treiblmaier, 2018).

### 1.4 Overbooking Risk

Without a shared, immutable ledger, hotels and OTAs may double-sell rooms,
leading to guest dissatisfaction and reputational damage. This problem is
inherent in centralized database architectures (Treiblmaier, 2018).

## 2. Proposed Blockchain Solution

Our solution replaces the OTA with a smart contract acting as a **trustless
escrow layer** between guest and hotel, following the principles outlined
by Nakamoto (2008) and extended by Buterin (2014) for programmable
transactions.

### 2.1 Core Mechanism

1. Guest browses available rooms (off-chain metadata)
2. Guest initiates booking via MetaMask, sending payment to the smart contract
3. Booking details are hashed using SHA-256 (NIST, 2015) and stored on-chain
4. Funds are held in escrow until check-in confirmation
5. Hotel confirms check-in → smart contract releases funds instantly
6. If hotel fails to confirm or cancels → automatic refund with penalty

This architecture aligns with Szabo's (1997) original concept of smart
contracts as self-executing agreements with the terms directly written
into code.

### 2.2 Disruptive Impact

- **Zero intermediary fees** → lower prices for guests, higher margins for
  hotels (Iansiti and Lakhani, 2017)
- **Instant settlement** → improved hotel cash flow
- **Immutable booking records** → elimination of overbooking disputes
  (Beck, Müller-Bloch and King, 2018)
- **Transparent, code-enforced policies** → no hidden clauses

## 3. Recent Blockchain Advancements Incorporated

- **Layer 2 Solutions (Polygon):** Reduces gas fees from $5-50 to
  $0.01-0.10, making micro-transactions viable (Polygon Technology, 2023;
  Ethereum Foundation, 2024)
- **IPFS Integration:** Booking receipts and T&C documents stored off-chain
  with on-chain hash verification (Benet, 2014)
- **Account Abstraction (ERC-4337):** Enables gasless onboarding for
  non-technical users (future enhancement)

## 4. References

- Beck, R., Müller-Bloch, C. and King, J.L., 2018. Governance in the blockchain age. _Proceedings of ICIS_, Seoul.
- Benet, J., 2014. _IPFS - Content addressed, versioned, P2P file system_.
- Buterin, V., 2014. _A next-generation smart contract and decentralized application platform_. Ethereum White Paper.
- European Commission, 2017. _Commission staff working document on the online platform economy_. SWD(2017) 215 final.
- Iansiti, M. and Lakhani, K.R., 2017. The truth about blockchain. _Harvard Business Review_, 95(1), pp.118-127.
- Nakamoto, S., 2008. _Bitcoin: A peer-to-peer electronic cash system_.
- NIST, 2015. _FIPS PUB 180-4: Secure Hash Standard_.
- Önder, I. and Treiblmaier, H., 2018. Blockchain and the travel industry: a survey. _Journal of Travel & Tourism Marketing_, 35(9), pp.1225-1239.
- Phocuswright, 2023. _U.S. metasearch and OTA market dynamics_.
- Polygon Technology, 2023. _Polygon whitepaper_.
- Statista, 2024. _Online travel agent (OTA) commission rates worldwide_.
- Szabo, N., 1997. Formalizing and securing relationships on public networks. _First Monday_, 2(9).
- Tapscott, D. and Tapscott, A., 2016. _Blockchain revolution_. New York: Penguin.
- Treiblmaier, H., 2018. The impact of the blockchain on the supply chain. _Supply Chain Management: An International Journal_, 23(6), pp.545-559.
