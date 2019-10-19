FROM ruby:2.4.3
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client
RUN mkdir /catellis-web-api
WORKDIR /catellis-web-api
COPY Gemfile /catellis-web-api/Gemfile
COPY Gemfile.lock /catellis-web-api/Gemfile.lock
RUN gem install bundler
RUN bundle install
COPY . /catellis-web-api

# Add a script to be executed every time the container starts.
#COPY entrypoint.sh /usr/bin/
#RUN chmod +x /usr/bin/entrypoint.sh
#ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start the main process.
#CMD ["rails", "server", "-b", "0.0.0.0"]

ADD . .
CMD ["puma"]
