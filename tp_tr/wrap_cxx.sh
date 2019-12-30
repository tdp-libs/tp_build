#!/bin/bash

TP_CXX=$1
TP_CC1=$2
shift
shift
TP_ARGS=$@

#$TP_CXX -no-integrated-cpp -B$TP_CC1 $TP_ARGS
$TP_CXX $TP_ARGS
#$TP_CXX -no-integrated-cpp -B/usr/libexec/gcc/x86_64-redhat-linux/9/ $TP_ARGS

$TP_CXX -E $TP_ARGS 

