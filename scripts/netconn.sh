#!/bin/bash
touch /tmp/netall.txt
which ifconfig && IP=ifconfig || IP="ip addr sh"
LOC=$($IP | grep -Eoie '([0-9]+\.){3}[0-9]+' -e '\b([0-9A-Fa-f]{1,4}:){7}[0-9A-Fa-f]{1,4}\b' | grep -ve '^127' -e '255$' | tr '\n' ' ' | sed 's-\ -/localhost/g;s/-g')
lsof -nP -i | grep 'ESTABL' | grep -v 127.[0-9]*.[0-9]*.[0-9]*: | grep -v '\[::1\]' | tr -s ' ' | cut -d' ' -f1,3,9 | sed "s/${LOC}127.0.0.1/localhost/g;s/:[0-9]\+-/-/;s/\[//g;;s/\]//g;s/:\([0-9]\+\)$/ \1/;s/-\>/ /;s/->/ /">/tmp/netall.tmp
grep -Fxvf /tmp/netall.txt /tmp/netall.tmp > /tmp/netall.dif
mv /tmp/netall.txt /tmp/netall.tmp
cat /tmp/netall.tmp /tmp/netall.dif > /tmp/netall.txt
