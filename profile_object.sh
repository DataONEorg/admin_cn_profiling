#!/bin/bash

SPATH=$(dirname ${0})
DEST_FN="prof_object_100.svg"
PID_FILE="${SPATH}/iso_pangaea_pids.txt"
BASE_URL="https://cn-unm-1.dataone.org/cn/v2/object/"
PROFILER="./profiler.sh"
TOMCAT_PID=$(sudo -u tomcat7 jps | grep "Bootstrap" | awk '{print $1}')
echo "Start profiling jps id: ${TOMCAT_PID}"
sudo -u tomcat7 ${PROFILER} start -f "/tmp/${DEST_FN}" ${TOMCAT_PID}
cat ${PID_FILE} | while read PID; do
  URL="${BASE_URL}${PID}"
  echo ${URL}
  curl -s ${URL} > /dev/null
done
sudo -u tomcat7 ${PROFILER} stop -f "/tmp/${DEST_FN}" --title "getObject" ${TOMCAT_PID}
echo "Done profiling jps id: ${TOMCAT_PID}"
cp "/tmp/${DEST_FN}" "/var/www/profiling/${DEST_FN}"
