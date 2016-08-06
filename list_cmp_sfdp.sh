#!/bin/bash
  for file in `ls verify*txt`
  do
    bash compare_sfdp.sh -g golden.csv -v ${file}
  done
