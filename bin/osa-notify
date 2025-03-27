#!/bin/bash
# usage:  cmd | osa_notify.sh
/usr/bin/osascript 3<&0 <<'APPLESCRIPT'
  on run argv
    set stdin to do shell script "cat 0<&3"
        display notification stdin with title "osa_notify" sound name "Default"
    return stdin
  end run
APPLESCRIPT
