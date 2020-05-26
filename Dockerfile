FROM ruby:2.6.6-slim

RUN apt-get update && apt-get install -y build-essential gcc libc-dev \
 libmagickwand-dev libxml2-dev libxslt-dev \
 libsqlite3-dev --no-install-recommends && rm -rf /var/lib/apt/lists/*

WORKDIR /app
EXPOSE 3000
RUN groupadd -r app && useradd -r -g app app

RUN gem install bundler
RUN bundle config build.nokogiri --use-system-libraries


#
# Install rubygems
#
COPY Gemfile      /app/Gemfile
COPY Gemfile.lock /app/Gemfile.lock
RUN bundle install

# Add source and precompile assets
#
COPY . /app
ENV RAILS_ENV=production

RUN bundle exec rake db:migrate

CMD ["bundle", "exec", "rails", "server"]