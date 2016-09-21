FROM ruby:2.3.1

RUN bundle config --global frozen 1

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

ADD Gemfile /usr/src/app/
ADD Gemfile.lock /usr/src/app/
RUN RAILS_ENV=production bundle install --deployment --frozen --clean --without development --path vendor/bundle

COPY . /usr/src/app

ENV RAILS_ENV 'production'

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]
