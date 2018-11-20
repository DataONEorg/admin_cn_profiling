#!/bin/bash
#
# Profile metacat while handling getSystemMetadata requests
# Run this from the same folder as "profiler.sh"
#
TSTAMP=$(date +%Y-%m-%dT%H:%M:%S%z)
TBRIEF=$(date +%Y%m%dT%H%M)
SPATH=$(dirname ${0})
DEST_FN="${TBRIEF}_prof_meta_100.svg"
PID_FILE="${SPATH}/iso_pangaea_pids.txt"
BASE_URL="https://cn-unm-1.dataone.org/cn/v2/meta/"
PROFILER="./profiler.sh"
TOMCAT_PID=$(sudo -u tomcat7 jps | grep "Bootstrap" | awk '{print $1}')
echo "Start profiling jps id: ${TOMCAT_PID}"
sudo -u tomcat7 ${PROFILER} start -f "/tmp/${DEST_FN}" ${TOMCAT_PID}
TSTART=$(date +%s%N)
cat ${PID_FILE} | while read PID; do
  URL="${BASE_URL}${PID}"
  echo ${URL}
  curl -s ${URL}
done
TDELTA=$((($(date +%s%N) - TSTART)/1000000))
sudo -u tomcat7 ${PROFILER} stop -f "/tmp/${DEST_FN}" --title "getSystemMetadata (${TDELTA} msec) at ${TSTAMP}" ${TOMCAT_PID}
echo "Done profiling jps id: ${TOMCAT_PID}"
cp "/tmp/${DEST_FN}" "/var/www/profiling/${DEST_FN}"
sudo -u tomcat7 rm "/tmp/${DEST_FN}"