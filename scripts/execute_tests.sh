#!/bin/sh

# wait for the selenium grid browser nodes to register with the selenium grid hub
if [ -n "$CI" ]; then
  sleep 15
else
  sleep 5
fi

ruby grid/testrunner.rb
