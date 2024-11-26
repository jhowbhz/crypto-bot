FROM ubuntu:22.04

LABEL maintainer="Daniel Espendiller <daniel@espendiller.net>"

# Update and install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    sqlite3 \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Install Node.js and npm
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs && \
    npm install -g npm@latest && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /usr/src/app

# Install app dependencies
COPY package.json /usr/src/app/
RUN npm install --production && \
    npm cache clean --force

# Bundle app source
COPY . /usr/src/app

# Apply all patches in app
RUN npm run postinstall

EXPOSE 8081
CMD ["npm", "run", "start"]
