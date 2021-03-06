ARG RUBY_VERSION=2.7.2-alpine

FROM ruby:${RUBY_VERSION} AS build
RUN apk add --update \
  build-base \
  ruby-dev

ARG RUBOCOP_VERSION=1.2.0
RUN gem install rubocop -v ${RUBOCOP_VERSION}

ARG RUBOCOP_PERFORMANCE_VERSION=1.8.1
RUN gem install rubocop-performance -v ${RUBOCOP_PERFORMANCE_VERSION}

ARG RUBOCOP_RAILS_VERSION=2.8.1
RUN gem install rubocop-rails -v ${RUBOCOP_RAILS_VERSION}

ARG RUBOCOP_RSPEC_VERSION=2.0.0
RUN gem install rubocop-rspec -v ${RUBOCOP_RSPEC_VERSION}

RUN rm -rf /usr/local/bundle/cache/*.gem \
 && find /usr/local/bundle/gems/ -name "*.c" -delete \
 && find /usr/local/bundle/gems/ -name "*.o" -delete

FROM ruby:${RUBY_VERSION}

LABEL io.whalebrew.name 'rubocop'
LABEL io.whalebrew.config.working_dir '/workdir'
WORKDIR /workdir

COPY --from=build /usr/local/bundle /usr/local/bundle

ENTRYPOINT ["rubocop"]
CMD ["--help"]
