FROM node:11-alpine
MAINTAINER lnkusuin

# 日本時刻の設定
RUN apk --update add tzdata && \
    cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
    apk del tzdata && \
    rm -rf /var/cache/apk/*

# ポート解放
EXPOSE 3000

COPY nuxt-sample-project /home/node/app

WORKDIR /home/node/app

RUN rm -rf node_modules .nuxt package-lock.json

# NODEアプリケーションのプロジェクトパスを設定
ENV NODE_PATH .
# プロジェクトルート
ENV APP_ROOT /home/node/app

RUN npm install --production
RUN npm run build

CMD npm run start