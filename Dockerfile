# Use Node.js base image
FROM node:18

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install dependencies
RUN npm install --no-audit --no-fund

# Copy all files
COPY . .

# Expose port
EXPOSE 3000

# Run app
CMD ["node", "app.js"]