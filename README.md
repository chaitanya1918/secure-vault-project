# Secure Vault with Authorization Manager

This project demonstrates a secure Ethereum smart contract system where
withdrawals from a vault are allowed only through verified, one-time
authorizations. The design prevents unauthorized access and replay attacks
and is fully deployable in a local Docker-based environment.

---

## 📌 Project Overview

The system is composed of two smart contracts:

### 1. AuthorizationManager
- Validates withdrawal permissions using cryptographic signatures
- Ensures each authorization can be used only once
- Prevents replay attacks

### 2. SecureVault
- Holds pooled ETH funds
- Executes withdrawals only after authorization verification
- Delegates permission checks to AuthorizationManager

---

## 📁 Repository Structure
/ ├─ contracts/ │  ├─ AuthorizationManager.sol │  └─ SecureVault.sol ├─ scripts/ │  └─ deploy.js ├─ docker/ │  ├─ Dockerfile │  └─ entrypoint.sh ├─ docker-compose.yml ├─ tests/ │  └─ system.spec.js └─ README.md
## ⚙️ Prerequisites

- Git
- Docker Desktop (with Docker Compose enabled)
- Internet connection (for installing dependencies)

---

## 🚀 Running the Project Locally

### 1️⃣ Start Local Blockchain and Deploy Contracts

Run the following command from the project root directory:

bash
docker compose up --build

This will:

Start a local Ethereum blockchain (Ganache)

Compile smart contracts

Deploy AuthorizationManager

Deploy SecureVault with the AuthorizationManager address

Expose an RPC endpoint at http://localhost:8545

Output deployed contract addresses to logs

Save deployment information in deployments.json



---

📄 Deployment Output

After deployment, the following details are printed in the logs:

Network name

Network chain ID

AuthorizationManager contract address

SecureVault contract address


The same information is saved to:

deployments.json

This makes it easy for evaluators to verify deployments.


---

🔐 Authorization Flow (Manual Validation)

Step 1: Authorization Generation (Off-chain)

A trusted signer generates an authorization by signing:

Vault contract address

Recipient address

Withdrawal amount

Unique authorization ID


This signature acts as a one-time withdrawal permission.


---

Step 2: Authorization Consumption (On-chain)

1. A user calls SecureVault.withdraw(...)


2. SecureVault forwards the request to AuthorizationManager.verifyAuthorization(...)


3. AuthorizationManager validates:

Signature authenticity

Authorization has not been used before



4. If valid:

Authorization is marked as consumed

Funds are transferred to the recipient





---

❌ Failed Withdrawal Scenarios

Withdrawals will fail if:

The authorization signature is invalid

The authorization ID is reused

The vault does not have enough balance



---

🧪 Automated Testing

The project includes automated system tests in:

tests/system.spec.js

The tests demonstrate:

Successful withdrawal with valid authorization

Failed withdrawal when the same authorization is reused
