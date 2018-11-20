#!/bin/bash
#
# Profile metacat while handling getSystemMetadata requests
# Run this from the same folder as "profiler.sh"
#
TSTAMP=$(date +%Y-%m-%dT%H:%M:%S%z)
TBRIEF=$(date +%Y%m%dT%H%M)
SPATH=$(dirname ${0})
DEST_FN="${TBRIEF}_prof_meta_100_diff"
PID_FILE="${SPATH}/iso_pangaea_pids.txt"
BASE_URL="https://cn-unm-1.dataone.org/cn/v2/meta/"
PROFILER="./profiler.sh"
TOMCAT_PID=$(sudo -u tomcat7 jps | grep "Bootstrap" | awk '{print $1}')

# Profile run A
echo "Start profiling jps id: ${TOMCAT_PID}"
sudo -u tomcat7 ${PROFILER} start -f "/tmp/${DEST_FN}.A.out" -o collapsed ${TOMCAT_PID}
TSTART=$(date +%s%N)
cat ${PID_FILE} | while read PID; do
  URL="${BASE_URL}${PID}"
  echo ${URL}
  curl -s ${URL}
done
TDELTA_A=$((($(date +%s%N) - TSTART)/1000000))
sudo -u tomcat7 ${PROFILER} stop -f "/tmp/${DEST_FN}.A.out" -o collapsed ${TOMCAT_PID}
echo "Done profiling jps id: ${TOMCAT_PID}"

# Profile run B
echo "Start profiling jps id: ${TOMCAT_PID}"
sudo -u tomcat7 ${PROFILER} start -f "/tmp/${DEST_FN}.B.out" -o collapsed ${TOMCAT_PID}
TSTART=$(date +%s%N)
cat ${PID_FILE} | while read PID; do
  URL="${BASE_URL}${PID}"
  echo ${URL}
  curl -s ${URL}
done
TDELTA_B=$((($(date +%s%N) - TSTART)/1000000))
sudo -u tomcat7 ${PROFILER} stop -f "/tmp/${DEST_FN}.B.out" -o collapsed ${TOMCAT_PID}
echo "Done profiling jps id: ${TOMCAT_PID}"

# Compute deltas
FG="${SPATH}/FlameGraph/flamegraph.pl"
FG_TITLE="delta getSystemMetadata runs A=${TDELTA_A} B=${TDELTA_B} msec at ${TSTAMP}"
FGDIFF="${SPATH}/FlameGraph/difffolded.pl"

${FGDIFF} "/tmp/${DEST_FN}.A.out" "/tmp/${DEST_FN}.B.out" | ${FG} --title "${FG_TITLE}"> "/tmp/${DEST_FN}.svg"
cp "/tmp/${DEST_FN}.svg" "/var/www/profiling/${DEST_FN}.svg"
#sudo -u tomcat7 rm "/tmp/${DEST_FN}.svg"
#sudo -u tomcat7 rm "/tmp/${DEST_FN}.A.out"
#sudo -u tomcat7 rm "/tmp/${DEST_FN}.B.put"
