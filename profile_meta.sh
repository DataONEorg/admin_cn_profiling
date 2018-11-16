#!/bin/bash

DEST_FN="prof_meta_01.svg"
BASE_URL="https://cn-unm-1.dataone.org/cn/v2/meta/"
PROFILER="./profiler.sh"
TOMCAT_PID=$(sudo -u tomcat7 jps | grep "Bootstrap" | awk '{print $1}')
PIDS=(00682b835f37f807d057e5ccf19f0a46 006831c87eca8c64344b8cb3db0a60fb 00683912f000d3c7007906fbfc4a1f9b 00684d2cd5da265e385a94d67e21d197 0068781d1c6eaf235a6e6d0d68181d3d)
PIDS=(00682b835f37f807d057e5ccf19f0a46)
sudo -u tomcat7 ${PROFILER} start -f "/tmp/${DEST_FN}" ${TOMCAT_PID}
for PID in ${PIDS[@]}; do
  URL="${BASE_URL}${PID}"
  echo ${URL}
  curl -s ${URL}
done
sudo -u tomcat7 ${PROFILER} stop -f "/tmp/${DEST_FN}" ${TOMCAT_PID}
cp "/tmp/${DEST_FN}" "/var/www/profiling/${DEST_FN}"
