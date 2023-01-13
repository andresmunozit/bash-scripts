#!/bin/bash
get_host_name() {
  host=$1
  account=$2
  echo "$account.$host"
}
