FROM nginx:1
MAINTAINER Freifunk Rhein-Sieg e.V. <technik@freifunk-rhein-sieg.net>
EXPOSE 80

RUN mkdir -p /project/
WORKDIR /project
RUN apt-get update -y && apt-get install -y git ruby ruby-dev rubygems build-essential
RUN gem install bundle
CMD git init && git remote add origin https://labcode-de@bitbucket.org/labcode-de/ffrsk.git && git fetch && git pull origin v2 && bundle install && bundle exec jekyll build && rm -rf /usr/share/nginx/html/* && cp -r _site/* /usr/share/nginx/html && echo "ready" && nginx -g "daemon off;"