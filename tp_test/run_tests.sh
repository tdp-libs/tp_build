#!/bin/bash

set -e

testCommands=`cat tests.txt`

results="\nTest Results:\n"
for testCommand in ${testCommands[@]}; do
  echo -e "\n\e[1;93mRunning test: \e[21m${testCommand}\e[39m"

  if ${testCommand}; then
    results="${results}    \e[32mPassed: ${testCommand}\e[39m\n"
  else
    results="${results}    \e[31mFailed: ${testCommand}\e[39m\n"
  fi
done

echo -e "${results}"

