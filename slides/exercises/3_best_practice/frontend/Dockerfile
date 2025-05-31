FROM node:latest
WORKDIR /app
COPY . .
RUN npm i
RUN npm run build
EXPOSE 80
ENTRYPOINT ["npm", "run", "preview", "--", "--port", "80"]
