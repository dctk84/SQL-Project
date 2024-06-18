
# Crypto Currency Project

## Overview

The Crypto Currency Project aims to design a data model for a data warehouse based on the raw trading data of a crypto wallet platform, referred to as K. This platform supports millions of users globally, allowing them to manage and swap various cryptocurrencies.

## Business Model

### Platform K

Platform K is a global crypto wallet platform with the following features:
- **User Management**: Each user can have one or multiple wallets, each containing various cryptocurrencies.
- **Registration**: Users import their wallets into the platform upon registration.
- **Anonymity**: Users do not need to disclose their identities. However, device information such as device type, platform (web/mobile), operating system, and IP address (with geographic location) is recorded.
- **Crypto Swapping**: Users can swap cryptocurrencies within their wallets based on their belief in future value increases.
- **Cryptocurrency Types**:
  - **Stable Coins**: Pegged to real-world currencies like USD, YEN, RMB, or gold.
  - **Alt Coins**: Market-dependent cryptocurrencies like Bitcoin.
- **Transaction Fees**: The platform charges a 2% transaction fee, paid in the swapped cryptocurrency.

### Example Transaction

If a user swaps Crypto A (valued at $1 per token) for Crypto B (valued at $0.5 per token), they will receive 2 tokens of Crypto B for 1 token of Crypto A. The platform charges a 2% fee in Crypto B.

## Data Modelling

### Current Data Structure

The company's trading data is currently stored as a large, unprocessed dataset. The goal is to design a data model for a data warehouse based on this raw data.

### Data Dictionary

The following table describes the fields in the raw dataset:

| Field Name            | Description                                        |
|-----------------------|----------------------------------------------------|
| `txn_id`              | Transaction identifier                             |
| `wallet_address`      | Wallet address                                     |
| `volume`              | Transaction volume                                 |
| `date`                | Transaction date                                   |
| `platform`            | Transaction platform (web/mobile)                  |
| `source_token`        | Initial crypto token code                          |
| `dest_token`          | Swapped crypto token code                          |
| `source_amount`       | Amount of source crypto                            |
| `source_price`        | Price of one source crypto token                   |
| `dest_amount`         | Amount of destination crypto                       |
| `dest_price`          | Price of one destination crypto token              |
| `country_code`        | Country code                                       |
| `os`                  | Operating system                                   |
| `source_kind`         | Type of source crypto (stable/alt coin)            |
| `dest_kind`           | Type of destination crypto (stable/alt coin)       |
| `latitude_(average)`  | Average latitude of the country                    |
| `longitude_(average)` | Average longitude of the country                   |
| `country`             | Country name                                       |
| `source_anchor`       | Anchor value of the source crypto token            |
| `dest_anchor`         | Anchor value of the destination crypto token       |

## Objectives

- Design a data model for the company's data warehouse.
- Process and structure the raw trading data for efficient analysis and reporting.


