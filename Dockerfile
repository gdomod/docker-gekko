FROM node:8.9.3

MAINTAINER Gdo Mod <me@gdomod.de>

RUN mkdir -p /gekko && \
    git clone -b stable https://github.com/askmike/gekko.git /gekko

COPY UIconfig.js /gekko/web/vue/


WORKDIR /gekko

RUN npm install --production; \
    # install TA-lib, Redis, PostgreSQL modules
    npm install talib@1.0.2 redis@0.10.0 pg --production; \

    # Update api
    sed -i "s/require('btc-china-fork')/require('btc-china')/g" \
        exchanges/btcc.js importers/exchanges/btcc.js; \
    npm uninstall --save btc-china-fork; \

    npm install bitfinex-api-node btc-china --save --production

VOLUME /gekko/history

CMD ["node", "gekko", "--ui", "--config" , "/gekko/userconfig/config.js"]

