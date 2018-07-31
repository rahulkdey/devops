FROM node:8

ARG APP_PORT=port
ENV APP_PORT ${APP_PORT}

# Create app directory
WORKDIR /usr/src/app


ADD VERSION .

# Install app dependencies
# A wildcard is used to ensure both package.json AND package-lock.json are copied
# where available (npm@5+)
COPY src/package*.json ./

RUN npm install
# If you are building your code for production
# RUN npm install --only=production

# Bundle app source
COPY src .
COPY conf/*.tmpl ./
COPY build/*.json ./

EXPOSE  ${APP_PORT}
CMD [ "npm", "start" ]
