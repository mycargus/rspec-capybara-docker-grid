[![Build Status](https://travis-ci.org/mycargus/rspec-capybara-docker-grid.svg?branch=master)](https://travis-ci.org/mycargus/rspec-capybara-docker-grid)

# A Dockerized Selenium Grid with RSpec and Capybara

I built this project to quickly provision a dockerized environment for running
UI tests against a dockerized app. It employs a dockerized [Selenium Grid]
which yields a far more cost-effective CI solution compared to purchasing and
maintaining dedicated machines.

I've included bash scripts in the `bin/` directory as wrappers for the
`docker-compose` commands. Hopefully, once you've completed the initial setup,
you won't have to recall any docker commands. :smiley:

Both RSpec and Capybara are automatically provisioned in the `testrunner` docker
image. You can easily customize their configurations in `spec/spec_helper.rb`.

## Dependencies

- a clone of this repo on your machine
- [Docker]

## Setup

Here's the default workflow when writing RSpec tests in this project:

- `bin/build && bin/start && bin/test`
- make changes to files inside the spec/ directory
- verify changes with `bin/build && bin/start && bin/test`

:sadtrombone:

To make your life easier, first do this:

```bash
cp docker-compose.dev.override.yml docker-compose.override.yml
```

Now any changes you make within this repo on your host file system will
automatically show up in the `testrunner` docker container. Here's your new
workflow:

- `bin/build && bin/start && bin/test`
- make changes to files inside the spec/ directory
- `bin/test`

:party:

Some folks have reported file permission issues with this workflow, so YMMV.

### Where do I add my app?

By default this project will use a bare-bones Sinatra web [app] as the system
under test (SUT). If you want to replace that default web app with your own,
open the `docker-compose.yml` file, find the `web` service configuration, and
replace `mycargus/hello_docker_world:master` with your app's docker image label.

For example:

```yaml
web:
  image: my-app-under-test:master
```

If you're not sure how to create or pull a docker image, I recommend working
through the official Docker tutorial located on their website.

## How do I execute the tests?

Start the Selenium hub, the SUT, and the Selenium browser nodes:

```bash
bin/start
```

Execute the tests with Rspec and Capybara from inside the `testrunner` container:

```bash
bin/test
```

When you're done, stop and remove the docker containers:

```bash
bin/stop
```

## I want to see the app under test. How can I do that?

If you're using the default web app provided, then open your browser and go to
<http://locahost:8080>.

If you're using your own web app, make sure to expose a port in your web app's
Dockerfile. For example, if you have `EXPOSE 9887` in your web app's Dockerfile,
then you can view it at <http://localhost:9887>.

## Can I view the Selenium grid console?

Yep! After having started the Selenium hub and nodes (`bin/start`), open a
browser and go to <http://localhost:4444>, then click the 'console' link.

## A test is failing. How do I debug it?

Start the Selenium hub, the app under test, and the Selenium _debug_ browser
nodes:

```bash
bin/debug_start
```

View the chrome debug node via VNC (password: `secret`):

```bash
open vnc://localhost:5900
```

View the firefox debug node via VNC (password: `secret`):

```bash
open vnc://localhost:5901
```

Next execute the tests against the browser nodes and watch them run in the VNC
window(s):

```bash
bin/test
```

Again, once you're finished:

```bash
bin/stop
```

[app]: https://github.com/mycargus/hello_docker_world
[docker]: https://docs.docker.com/
[selenium grid]: https://github.com/SeleniumHQ/docker-selenium
