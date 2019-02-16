[![Build Status](https://travis-ci.org/mycargus/rspec-capybara-docker-grid.svg?branch=master)](https://travis-ci.org/mycargus/rspec-capybara-docker-grid)

# A Dockerized Selenium Grid with RSpec and Capybara

I built this project to quickly provision an environment for running
UI tests against a dockerized app. It employs a dockerized [Selenium Grid](https://github.com/SeleniumHQ/selenium/wiki/Grid2), which yields a far more cost-effective CI solution compared to purchasing and maintaining *n* dedicated machines.

I've included bash scripts in the `/bin` directory as wrappers for the `docker-compose` commands. Hopefully, once you've completed the initial setup, you won't have to recall any docker commands. :smiley:

Both RSpec and Capybara are automatically provisioned in the `testrunner` docker image. As usual, you can easily customize their configurations in `spec/spec_helper.rb`.

## Dependencies (OSX)

1. a copy of this repo on your machine
2. [homebrew package manager](http://brew.sh/)
3. docker, docker-machine, and docker-compose: `$ brew install docker docker-machine docker-compose`
4. optional extras to make your life easier: [dinghy](https://github.com/codekitchen/dinghy)

## Dependencies (Linux)

1. a copy of this repo on your machine
2. [docker and docker-compose](https://docs.docker.com/engine/installation/linux/)
3. optional extras to make your life easier: [dory](https://github.com/FreedomBen/dory)

### A note on dinghy and dory

`dinghy` and `dory` are excellent Docker utilities for MacOSX and Linux, respectively. They simplify your dockerized
development workflow in multiple ways, perhaps the most convenient of which is this: instead of viewing your dockerized
web app in your browser with `http://$(docker-machine ip):<port>`, you can simply go to `http://myapp.docker`.

_Both `dinghy` and `dory` are optional dependencies, and one may certainly use the bare-bones Docker ecosystem
(and [docker-grid-rspec-capybara](https://github.com/mycargus/docker-grid-rspec-capybara)) without them._

## Setup

By default this project will use [a bare-bones Sinatra web app](https://github.com/mycargus/hello_docker_world) as the
app under test (AUT).

If you'd like to see this project in action before adding your app, go ahead and skip to the
["How do I execute the tests?"](https://github.com/mycargus/docker-grid-rspec-capybara/blob/master/README.md#how-do-i-execute-the-tests) section.

### Where do I add my app?

Add the docker image of the AUT to the `docker-compose.yml` file under the `web` service container.

If you're using `dinghy` or `dory`, be sure to define the AUT's virtual URL (a default is provided). For example:

```
web:
  image: my-app-under-test:latest
  environment:
    VIRTUAL_HOST: myapp.docker
```

That was easy!

If you're not sure how to create or pull a docker image, I recommend working through the official Docker tutorial located on
their website.

## How do I execute the tests?

Start the Selenium hub, the AUT, and the Selenium browser nodes:

```sh
$ bin/start
```

Execute the tests with Rspec and Capybara from inside the `testrunner` container:

```sh
$ bin/test
```

When you're done, stop and remove the docker containers:

```sh
$ bin/stop
```

## I want to see the app under test. How can I do that?

Open your browser and go to http://hello.docker. Easy!

If you changed the value of `VIRTUAL_HOST` for the web service in your
docker-compose.yml config, then you'll want to open that URL instead.

## Can I view the Selenium grid console?

Yep! After having started the Selenium hub and nodes (`$ npm start`), open a
browser and go to [http://selenium.hub.docker](http://selenium.hub.docker), then click the 'console' link.

## A test is failing. How do I debug it?

Start the Selenium hub, the app under test, and the Selenium *debug* browser nodes:

```sh
$ bin/debug_start
```

View the chrome debug node via VNC (password: `secret`):

```sh
$ open vnc://node.chrome.debug.docker
```

View the firefox debug node via VNC (password: `secret`):

```sh
$ open vnc://node.firefox.debug.docker
```

Next execute the tests against the debug nodes:

```sh
$ bin/test
```

Again, once you're finished:

```sh
$ bin/stop
```

