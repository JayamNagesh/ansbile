#!/bin/sh
load=`uptime | awk -F " " '{print $6,$7,$8,$9,$10}'`
echo "Load is $load";
