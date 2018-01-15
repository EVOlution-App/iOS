#!/bin/bash

ruby --version | grep -i `cat .ruby-version`
if [ $? -ne 0 ]; then
  echo "Loading rbenv"
  eval "$(rbenv init -)"
  ruby --version
fi
$1
