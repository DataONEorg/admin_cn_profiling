#!/bin/bash

DURATION="120"
DEST_FN="prof_background_${DURATION}.svg"
BASE_URL="https://cn-unm-1.dataone.org/cn/v2/meta/"
PROFILER="./profiler.sh"
TOMCAT_PID=$(sudo -u tomcat7 jps | grep "Bootstrap" | awk '{print $1}')
echo "Start profiling jps id: ${TOMCAT_PID}"
sudo -u tomcat7 ${PROFILER} -d ${DURATION} -f "/tmp/${DEST_FN}" --title "background_${DURATION}" --width 2000 ${TOMCAT_PID}
echo "Done profiling jps id: ${TOMCAT_PID}"
cp "/tmp/${DEST_FN}" "/var/www/profiling/${DEST_FN}"
