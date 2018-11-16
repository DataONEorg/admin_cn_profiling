#!/bin/bash

BASE_URL="https://cn-unm-1.dataone.org/cn/v2/meta/"
PROFILER="async-profiler/profiler.sh"
TOMCAT_PID=$(sudo -u tomcat7 jps | grep "Bootstrap" | awk '{print $1}')
PIDS=()
for PID in ${PIDS[@]}; do
  URL="${BASE_URL}${PID}"
  echo ${URL}
done
