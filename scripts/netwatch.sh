#!/bin/bash
touch /tmp/netwatch.log 
which ifconfig && IP=ifconfig || IP="ip addr sh"
LOC=$($IP | grep -Eoie '([0-9]+\.){3}[0-9]+' -e '\b([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}\b' | grep -ve '^127' -e '255$' | tr '\n' ' ' | sed 's-\ -/\$HOSTNAME/g;s/-g')
lsof -nP -i | grep 'ESTABL\|LISTEN\|UDP' | grep -v 127.[0-9]*.[0-9]*.[0-9]*: | grep -v '\[::1\]' | tr -s ' ' | cut -d' ' -f1-3,8,9 | sed "s/${LOC}127.0.0.1/$HOSTNAME/g;s/:[0-9]\+-/-/;s/\[//g;;s/\]//g;s/:\([0-9]\+\)$/ \1/;s/-\>/ /;s/->/ /" | sort > /tmp/netwatch.tmp
diff /tmp/netwatch.log /tmp/netwatch.tmp | grep '^[<>]' | sed 's/^</CLOSED/;s/^>/OPENED/' | xargs -L1 logger -t netwatch
mv /tmp/netwatch.tmp /tmp/netwatch.log
