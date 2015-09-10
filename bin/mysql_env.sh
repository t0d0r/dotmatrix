#!/usr/bin/env bash

if [ "$1x" != "x" ]; then
  version=$1
else
  version=`brew list | grep mysql | head -1`
fi
mysql_bin_path=`brew list $version 2> /dev/null| egrep 'bin/mysql'  | head -1`
if [ ! -z ${mysql_bin_path} ]; then
#  echo Using $mysql_bin_path
  export PATH=$PATH:`dirname $mysql_bin_path`
fi
