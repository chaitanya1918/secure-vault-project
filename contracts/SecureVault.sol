// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "./AuthorizationManager.sol";

// Holds pooled funds and executes withdrawals
contract SecureVault {
    // Stores reference to AuthorizationManager
    AuthorizationManager public authorizationManager;

    event Deposit(address indexed from, uint256 amount);
    event Withdrawal(address indexed to, uint256 amount);

    constructor(address _authorizationManager) {
        authorizationManager = AuthorizationManager(_authorizationManager);
    }

    // Accept deposits
    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function withdraw(
        address payable recipient,
        uint256 amount,
        bytes32 authorizationId,
        bytes calldata signature
    ) external {
        // Request authorization validation
        bool allowed = authorizationManager.verifyAuthorization(
            address(this),
            recipient,
            amount,
            authorizationId,
            signature
        );
        require(allowed, "Authorization failed");

        // Transfer funds
        require(address(this).balance >= amount, "Insufficient balance");
        (bool success, ) = recipient.call{value: amount}("");
        require(success, "Transfer failed");

        emit Withdrawal(recipient, amount);
    }
}