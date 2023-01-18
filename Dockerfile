FROM instructure/ruby:2.7

USER root

WORKDIR /usr/src/app/

COPY --chown=docker:docker Gemfile Gemfile.lock ./

USER docker
RUN bundle install --quiet --jobs 8
USER root

COPY --chown=docker:docker . ./

USER docker
