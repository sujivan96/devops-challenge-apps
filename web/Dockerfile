FROM node:14
ENV PORT=3000
ENV API_HOST=http://localhost:3001
# Set the working directory
WORKDIR /usr/src/app

# Copy the package.json and package-lock.json
COPY package*.json ./

# Install npm
RUN npm install

# Copy application code
COPY . .

# Expose port
EXPOSE $PORT

#run the app
CMD ["npm", "start"]
