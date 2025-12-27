version: "3.9"

services:
  blockchain:
    image: trufflesuite/ganache:latest
    container_name: local-blockchain
    ports:
      - "8545:8545"
    command:
      - "--accounts=10"
      - "--deterministic"
      - "--host=0.0.0.0"

  deployer:
    build:
      context: .
      dockerfile: docker/Dockerfile
    container_name: contract-deployer
    depends_on:
      - blockchain
    environment:
      RPC_URL: http://blockchain:8545
    command: ["sh", "./docker/entrypoint.sh"]