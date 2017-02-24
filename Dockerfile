from ruby:2.1.6

RUN mkdir -p /app/lib/polleverywhere/
WORKDIR /app

COPY Gemfile /app/
COPY polleverywhere.gemspec /app/
COPY lib/polleverywhere/version.rb /app/lib/polleverywhere/
RUN bundle install

COPY . /app
