FROM node:12-alpine
WORKDIR /app
COPY package.json ./
RUN npm install
COPY ./ ./app
EXPOSE 8080
CMD [ "npm", "start" ]
