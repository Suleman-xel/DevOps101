FROM node:14

WORKDIR /

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build


FROM nginx:alpine
COPY --from=0 /build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]