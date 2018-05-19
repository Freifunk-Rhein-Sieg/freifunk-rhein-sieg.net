FROM nginx:1
MAINTAINER Freifunk Rhein-Sieg e.V. <technik@freifunk-rhein-sieg.net>
EXPOSE 80

RUN mkdir -p /project/
WORKDIR /project
RUN apt-get update -y && apt-get install -y git ruby ruby-dev rubygems build-essential cron
RUN gem install bundle
RUN git init && git remote add origin https://gitlab.com/labcode-de/ffrs-website.git
RUN touch /etc/cron.d/update && touch /srv/update.sh && chmod 775 /srv/update.sh && chmod 644 /etc/cron.d/update && touch /var/log/cron.log
RUN echo "cd /project && git pull origin v2 && /usr/local/bin/bundle exec jekyll build && rm -rf /usr/share/nginx/html/* && cp -r _site/* /usr/share/nginx/html" > /srv/update.sh
RUN echo "*/1 * * * * root /srv/update.sh >> /var/log/cron.log 2>&1" > /etc/cron.d/update
CMD git fetch && git pull origin v2 && bundle install && bundle exec jekyll build && rm -rf /usr/share/nginx/html/* && cp -r _site/* /usr/share/nginx/html && echo "ready" && /etc/init.d/cron start && nginx -g "daemon off;"
