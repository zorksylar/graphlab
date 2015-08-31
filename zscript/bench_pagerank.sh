#!/bin/bash

HOME=/home/zork/dev-pla/graphlab/zscript
EXE=${HOME}/pagerank.sh

function run_pagerank {
  echo " run pagerank with option $1 $2 $3 $4"
  ${EXE}  --node=$1 --np=$2 --niters=30  --graph=$3 --net=$4 >> ${HOME}/bench_log
} # end of function run_pagerank



for net in "1g"
do
  for graph in "tw"
  do
    for node in 8
    do
      for np in 1 4 8 16
      do
        run_pagerank $node $np $graph $net
      done
    done
  done
done


