# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What This Is

A dockerized Selenium Grid test harness that runs RSpec/Capybara UI tests against a dockerized app. Tests run against both Firefox and Chrome browser nodes via Selenium Grid 3.

## Commands

All operations require Docker. Use the `bin/` wrappers:

```bash
bin/build      # Build the testrunner docker image
bin/start      # Start hub, web app, and browser nodes (firefox + chrome)
bin/test       # Run all specs inside the testrunner container
bin/stop       # Kill and remove all containers
bin/start-debug  # Start with VNC-enabled debug nodes instead of standard nodes
```

Standard workflow:
```bash
bin/build && bin/start && bin/test
```

### Local Development (file sync)

Copy the dev override to avoid rebuilding on every spec change:
```bash
cp docker-compose.dev.override.yml docker-compose.override.yml
```

This mounts the repo into the testrunner container, so only `bin/test` is needed after spec changes.

### Running a Single Spec

Pass RSpec arguments via the testrunner container directly:
```bash
docker-compose run testrunner rspec spec/features/example_spec.rb
```

### Debugging with VNC

```bash
bin/start-debug
open vnc://localhost:5900  # Firefox (password: secret)
open vnc://localhost:5901  # Chrome (password: secret)
bin/test
```

Selenium Grid console: http://localhost:4444

## Architecture

- **`docker-compose.yml`** — defines all services: `hub` (Selenium Grid hub), `web` (app under test), `node-chrome`/`node-firefox` (standard nodes), `node-chrome-debug`/`node-firefox-debug` (VNC nodes), `testrunner`
- **`grid/testrunner.rb`** — iterates over `['firefox', 'chrome']`, registers a `:remote_browser` Capybara driver pointing at the hub for each, runs the full RSpec suite twice (once per browser), then clears examples between runs
- **`spec/spec_helper.rb`** — configures Capybara to use `APP_HOST` env var for the app URL and `:remote_browser` as the default driver; no local server is started
- **`Dockerfile`** — builds the `testrunner` image from `instructure/ruby:2.7`

## Customizing the App Under Test

Replace the `web` service image in `docker-compose.yml`:
```yaml
web:
  image: my-app-under-test:master
```

## Key Constraint

`selenium-webdriver` is pinned to `3.142.7` in the Gemfile to match the Selenium Grid 3 docker images (`selenium/hub:3.8.1`, `selenium/node-*:3.8.1`). Don't upgrade either independently.
