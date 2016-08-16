#!/bin/bash
  while getopts "g:v:" opt
  do
    case ${opt} in
      g) 
	golden=$OPTARG
	;;
      v)
	verify=$OPTARG
	;;
      *)
	exit
	;;
    esac
  done
  echo "Golden file: ${golden}"
  echo "Verify file: ${verify}"
  
  if [ -e ${golden} ] && [ -e ${verify} ]; then
    perl sfdp_cmp ${golden} ${verify} > ${golden/.csv/_result.csv}
    golden_line=`wc -l ${golden} | cut -d ' ' -f 1`
    result_line=`wc -l ${golden/.csv/_result.csv} | cut -d ' ' -f 1`
    echo "Total lines of Golden: ${golden_line}"
    echo "Total lines of Result: ${result_line}"
    if [ ${golden_line} != ${result_line} ]; then
      echo "something error"
    fi
    match=`grep -n 'O$' ${golden/.csv/_result.csv} | wc -l`
    fail=`grep -n 'X$' ${golden/.csv/_result.csv} | wc -l`
    echo "Match code: ${match} Fail code: ${fail}"
    if [ ${fail} -ne 0 ]; then
      echo "Fail list:"
      grep -n 'X$' ${golden/.csv/_result.csv}
    fi
    echo "done"
  else
    echo "not such file(s)"
    exit 1
  fi
  exit 0
