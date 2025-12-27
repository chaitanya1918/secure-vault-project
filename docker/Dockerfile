FROM node:18-alpine

# Set working directory
WORKDIR /app

# Copy dependency files
COPY package.json package-lock.json ./

# Install project dependencies
RUN npm install

# Copy entire project
COPY . .

# Compile smart contracts
RUN npx hardhat compile

# Execute deployment logic at container startup
CMD ["sh", "./docker/entrypoint.sh"]