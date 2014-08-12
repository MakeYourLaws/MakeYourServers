#!/bin/bash
output=`/usr/sbin/ufw status`
ret=$?
echo $output
exit $ret