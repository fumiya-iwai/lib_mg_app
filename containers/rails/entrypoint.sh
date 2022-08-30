#!/bin/bash

rm -f tmp/pids/server.pid
bundle
rails s -b '0.0.0.0'
