FROM node:18.18-alpine as builder

ENV NODE_ENV=development
WORKDIR /usr/src/app

COPY ./package.json ./
# COPY ./package.json ./yarn.lock ./
RUN yarn install --network-timeout 100000

COPY src src
COPY test test
COPY nest-cli.json nest-cli.json
COPY .eslintrc.js .eslintrc.js
COPY tsconfig*.json ./

RUN yarn build

FROM node:18.18-alpine as production

ENV NODE_ENV=production
ENV USERNAME=appuser
WORKDIR /usr/src/app

RUN apk update && apk add --no-cache shadow && apk upgrade libcrypto3 libssl3
RUN addgroup -S ${USERNAME} && \
  adduser \
  --disabled-password \
  --gecos "" \
  --home /usr/src/app \
  --ingroup ${USERNAME} \
  ${USERNAME}

COPY --from=builder /usr/src/app/package.json /usr/src/app/yarn.lock ./

RUN yarn install --only=production --network-timeout 100000
COPY --from=builder /usr/src/app/dist ./dist

USER appuser
CMD ["yarn", "start:prod"]
