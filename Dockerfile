FROM nginx:1
MAINTAINER Freifunk Rhein-Sieg e.V. <technik@freifunk-rhein-sieg.net>
EXPOSE 80

RUN mkdir -p /project/
WORKDIR /project
RUN apt-get update -y && apt-get install -y git ruby ruby-dev rubygems build-essential cron
RUN gem install bundle
RUN git init && git remote add origin https://gitlab.com/labcode-de/ffrs-website.git
RUN mkdir -p /etc/cron && touch /etc/cron/crontab && touch /srv/update.sh
RUN echo "git pull origin v2 && bundle exec jekyll build && rm -rf /usr/share/nginx/html/* && cp -r _site/* /usr/share/nginx/html" > /srv/update.sh
RUN echo "*/1 * * * * /bin/bash /srv/update.sh" > /etc/cron/crontab
RUN crontab /etc/cron/crontab

CMD git fetch && git pull origin v2 && bundle install && bundle exec jekyll build && rm -rf /usr/share/nginx/html/* && cp -r _site/* /usr/share/nginx/html && echo "ready" && nginx -g "daemon off;" && crond -f