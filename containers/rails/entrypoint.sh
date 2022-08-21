#!/bin/bash

rm -f tmp/pids/server.pid
bin/bundle
bin/rails s -b '0.0.0.0'
