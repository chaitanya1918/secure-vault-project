#!/bin/sh

echo "Starting container..."
echo "Deploying smart contracts..."

npx hardhat run scripts/deploy.js --network localhost

echo "Deployment completed"