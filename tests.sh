#!/usr/bin/env bash
set -e


function start() {
  docker network create nginx-proxy || true
  make install
}

function stop() {
  make remove
}

function test() {
  sleep 5
  docker ps | grep "michel-letsencrypt" | grep -q "Up" && echo "Container michel-letsencrypt is up."
  docker ps | grep "michel" | grep -q "Up" && echo "Container michel is up."
}

function test_all() {
  echo "=== START"

  start
  test
  stop

  echo "=== END"
}

test_all
