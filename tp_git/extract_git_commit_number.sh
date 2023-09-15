#!/bin/bash

if [ -d "../.git" ]; then
  if command -v git &> /dev/null; then
    cd ..
    git rev-list --count HEAD
  fi
fi
