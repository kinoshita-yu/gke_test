FROM golang AS build-env
RUN CGO_ENABLED=0 go get github.com/okzk/env-injector

FROM ruby:2.5.3-alpine

RUN apk add --no-cache ca-certificates
COPY --from=build-env /go/bin/env-injector /usr/local/bin/
ENTRYPOINT ["env-injector"]

CMD ["printenv"]

ENV APP_ROOT /docker_test

RUN mkdir $APP_ROOT
RUN mkdir /tmp/spring

RUN apk update && \
apk add less

WORKDIR $APP_ROOT

COPY Gemfile $APP_ROOT
COPY Gemfile.lock $APP_ROOT

COPY package.json $APP_ROOT
COPY yarn.lock $APP_ROOT

RUN apk add --no-cache git && \
git clone https://github.com/vishnubob/wait-for-it.git /usr/local/lib/wait-for-it &&\
ln -s /usr/local/lib/wait-for-it/wait-for-it.sh /usr/local/bin/wait-for-it &&\
apk del git

RUN apk add --no-cache \
libstdc++ \
tzdata \
mysql-dev \
nodejs \
ca-certificates \
curl-dev \
tzdata \
nodejs-npm \
bash && \
apk add --update --virtual .build-dependencies --no-cache \
build-base \
libxml2-dev \
libxslt-dev && \
npm install yarn -g && \
cp /usr/share/zoneinfo/Asia/Tokyo /etc/localtime && \
yarn install && \
gem install bundler -v 2.0.1 && \
bundle install -j4 && \
apk del .build-dependencies

RUN yarn install --pure-lockfile --ignore-engines \
&& yarn cache clean


COPY . $APP_ROOT
