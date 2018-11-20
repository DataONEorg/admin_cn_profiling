# admin_cn_profiling

Scripts etc for profiling CNs.


## Setup

These scripts make use of Async-Profiler: https://github.com/jvm-profiling-tools/async-profiler

On the system to be profiled, follow the kernel config flag setting steps described in async-profiler. Note that this does not work on the VMs running at UCSB because of the shared kernel virtualization in use there.

Then setup the profiler:

```
mkdir ~/profiling
cd ~/profiling
git co https://github.com/DataONEorg/admin_cn_profiling.git
cd admin_cn_profiling
git co https://github.com/jvm-profiling-tools/async-profiler.git
cd async-profiler
export JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"
make
```

Make a place for the resulting charts (check `/etc/group` for the sudo group on the system, here it is `admin`):

```
sudo mkdir /var/www/profiling
chgrp -R admin /var/www/profiling
chmod -R g+w /var/www/profiling
```

## Basic Operation

The profiler samples the call stack for the desired JVM at intervals then spits out a report. The basic process for running the profiler is:

1. Determine the process id and user for the application to profile, e.g.:

```
$ sudo -u tomcat7 jps
11218 Bootstrap
16556 Jps
```

2. Run the profiler, e.g. for a specific time of 30 seconds against the JVM process id of `11218` and output results to a flamegraph:

```
cd ~/profiling/admin_cn_profiling/async-profiler
GRAPH_TITLE="Profile at $(date +%Y-%m-%dT%H:%M:%S%z)"
./profile.sh -d 30 -f /tmp/profile.svg \
  --width 2000 \
  --title "${GRAPH_TITLE}" \
  11218
```

3. Copy the results to the web accessible folder and take a look in a browser:

```
cp /tmp/profile.svg /var/www/profiling
```

## Miscellanea

PIDS:

```
d1listobjects -C 100 -I -F "http://www.isotc211.org/2005/gmd-pangaea" > iso_pangaea_pids.txt
```

