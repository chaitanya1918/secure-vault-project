const { expect } = require("chai");
const { ethers } = require("hardhat");

describe("SecureVault System Test", function () {
  let authManager;
  let vault;
  let owner;
  let recipient;

  beforeEach(async function () {
    [owner, recipient] = await ethers.getSigners();

    // Deploy AuthorizationManager
    const AuthorizationManager = await ethers.getContractFactory(
      "AuthorizationManager"
    );
    authManager = await AuthorizationManager.deploy(owner.address);
    await authManager.deployed();

    // Deploy SecureVault
    const SecureVault = await ethers.getContractFactory("SecureVault");
    vault = await SecureVault.deploy(authManager.address);
    await vault.deployed();

    // Fund the vault with 1 ETH
    await owner.sendTransaction({
      to: vault.address,
      value: ethers.utils.parseEther("1"),
    });
  });

  it("allows withdrawal with valid authorization", async function () {
    const amount = ethers.utils.parseEther("0.1");
    const authorizationId = ethers.utils.id("auth-1");

    // Create authorization hash
    const messageHash = ethers.utils.solidityKeccak256(
      ["address", "address", "uint256