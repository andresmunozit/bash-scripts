#!/bin/bash

PUB_KEYS=$(ls -l -a ~/.ssh | grep .pub | grep .com | awk -v home="$HOME" '{print home"/.ssh/"$9}')

for key in $PUB_KEYS; do \
  echo "Path: $key"
  echo "Content:"
  cat "$key" && echo
done
