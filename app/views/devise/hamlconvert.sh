#!/bin/bash
if [ -z "$1" ]; then
  wdir="."
else
  wdir=$1
fi

for f in $( find . -name '*.erb' ); do
  out="${f%.erb}.haml"
  if [ -e $out ]; then
    echo "skipping $out; already exists"
    rm $f
  else
    echo "hamlifying $f"
    html2haml $f > $out
    rm $f
  fi
done

