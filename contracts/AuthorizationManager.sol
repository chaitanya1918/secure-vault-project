// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/utils/cryptography/ECDSA.sol";

/**
 * @title AuthorizationManager
 * @dev Responsible for validating withdrawal permissions
 *      and tracking whether an authorization has already been consumed.
 */
contract AuthorizationManager {
    using ECDSA for bytes32;

    /// @dev Tracks used authorization identifiers to prevent replay
    mapping(bytes32 => bool) private consumedAuthorizations;

    /// @dev Address allowed to sign withdrawal authorizations
    address public authorizedSigner;

    event AuthorizationConsumed(bytes32 indexed authorizationId);

    constructor(address _authorizedSigner) {
        require(_authorizedSigner != address(0), "Invalid signer");
        authorizedSigner = _authorizedSigner;
    }

    /**
     * @notice Verifies whether a withdrawal is permitted
     * @param vault Address of the vault contract
     * @param recipient Address receiving the withdrawal
     * @param amount Amount to withdraw
     * @param authorizationId Unique identifier for this authorization
     * @param signature Off-chain signature from the authorized signer
     * @return bool True if authorization is valid
     */
    function verifyAuthorization(
        address vault,
        address recipient,
        uint256 amount,
        bytes32 authorizationId,
        bytes calldata signature
    ) external returns (bool) {
        require(!consumedAuthorizations[authorizationId], "Authorization already used");

        // Create the signed message hash
        bytes32 messageHash = keccak256(
            abi.encodePacked(vault, recipient, amount, authorizationId)
        );

        // Recover signer
        bytes32 ethSignedMessageHash = messageHash.toEthSignedMessageHash();
        address recoveredSigner = ethSignedMessageHash.recover(signature);

        require(recoveredSigner == authorizedSigner, "Invalid authorization");

        // Mark authorization as consumed
        consumedAuthorizations[authorizationId] = true;

        emit AuthorizationConsumed(authorizationId);

        return true;
    }

    /**
     * @notice Checks if an authorization ID has already been consumed
     */
    function isAuthorizationConsumed(bytes32 authorizationId) external view returns (bool) {
        return consumedAuthorizations[authorizationId];
    }
}