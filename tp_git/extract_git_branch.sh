#!bash

if [ -d "../.git" ]; then
  if command -v git &> /dev/null; then
    cd ..
    git rev-parse --symbolic-full-name --abbrev-ref HEAD
  fi
fi
