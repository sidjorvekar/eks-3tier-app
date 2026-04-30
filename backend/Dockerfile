FROM node:18-slim
WORKDIR /app
COPY package*.json ./
RUN npm install express pg
COPY . .
EXPOSE 5000
CMD ["node", "server.js"]