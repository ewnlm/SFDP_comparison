#!/bin/bash
  temp="golden.csv"
  while [ $# -gt 1 ] 
  do
    option=$1
    case ${option} in
      -g|--golden)
	golden=$2
	shift
	;;
      -v|--verify)
	verify=$2
	shift
	;;
      *)
	echo "unknow option $1"
	;;
    esac
    shift
  done
  echo "Golden file: ${golden}"
  echo "Verify file: ${verify}"
  
  if [ -e ${golden} ] && [ -e ${verify} ]; then
    perl sfdp_cmp ${golden} ${verify} > ${golden/.csv/_result.csv}
    golden_line=`wc -l ${golden}`
    result_line=`wc -l ${golden/.csv/_result.csv}`
    echo "Golden line: ${golden_line}"
    echo "Result line: ${result_line}"
    if [ "${golden_line}" == "${result_line}" ]; then
      echo "something error"
    fi
    match=`grep -n 'O$' ${golden/.csv/_result.csv} | wc -l`
    fail=`grep -n 'X$' ${golden/.csv/_result.csv} | wc -l`
    echo "Match code: ${match} Fail code: ${fail}"
    if [ ${fail} -ne 0 ]; then
      echo "Fail list:"
      grep -n 'X$' ${golden/.csv/_result.csv}
    fi
  else
    echo "not such file(s)"
    exit 1
  fi
  exit 0
