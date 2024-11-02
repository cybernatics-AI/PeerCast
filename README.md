# Decentralized Video Streaming Platform

A Clarity smart contract for managing a decentralized video content platform, including subscriptions and revenue distribution.

## Overview

This smart contract implements a decentralized video streaming platform on the Stacks blockchain. It allows content creators to upload and monetize their videos, users to purchase access to videos and subscribe to premium services, and administrators to manage the platform.

## Features

- Video content management
- Premium subscriptions
- Revenue tracking and distribution
- Platform governance
- Access control for different user roles

## Key Functions

### Administrative Functions

- `set-platform-fee`: Set the platform fee percentage
- `toggle-contract-pause`: Pause or unpause the contract
- `add-administrator`: Add a new administrator

### Creator Functions

- `register-as-creator`: Register as a content creator
- `upload-video`: Upload a new video to the platform

### User Functions

- `purchase-video`: Purchase access to a specific video
- `subscribe-premium`: Subscribe to premium services

### Getter Functions

- `get-video-details`: Retrieve details of a specific video
- `get-creator-revenue`: Get the revenue earned by a creator
- `is-premium-subscriber`: Check if a user is a premium subscriber

## Data Structures

- `videos`: Stores video metadata and statistics
- `premium-subscribers`: Tracks premium subscriptions
- `creator-revenue`: Tracks revenue earned by creators
- `governance-proposals`: Stores governance proposals

## Error Handling

The contract includes various error codes for different scenarios, ensuring proper validation and error reporting.

## Usage

To use this contract, deploy it to the Stacks blockchain and interact with it using the provided public functions. Ensure that only authorized principals perform administrative actions.

## Security Considerations

- Only administrators can perform certain actions like setting fees and adding new administrators
- Contract can be paused in case of emergencies
- Access control is implemented for different user roles (admins, creators, users)

## Governance

The contract includes a basic governance system for managing platform parameters and upgrades.

## Initialization

Upon deployment, the contract owner is set as the first administrator, and the platform revenue is initialized.
