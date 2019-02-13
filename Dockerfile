FROM instructure/ruby:2.5

USER root

ENV APP_HOME /usr/src/app/
WORKDIR $APP_HOME

COPY Gemfile Gemfile.lock ./

USER docker
RUN bundle install --quiet --jobs 8
USER root

COPY --chown=docker:docker . ./

USER docker
