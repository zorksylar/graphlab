#!/bin/bash
export LD_LIBRARY_PATH=/home/zork/loclib/mpich-3.1.4/lib/

DATA_DIR=/home/zork/data/twitter
IN_NAME=twitter_rv.net
OUT_SUB_DIR=graphlab_out
OUT_PRE=gl_tw

ITERS=30
NP=16

EXEC=/home/zork/loclib/mpich-3.1.4/bin/mpiexec
APP=/home/zork/dev-pla/graphlab/release/toolkits/graph_analytics/pagerank
FHOST=/home/zork/dev-pla/graphlab/zscript/conf/machines_8

DATA_IN=${DATA_DIR}/${IN_NAME}
DATA_OUT_DIR=${DATA_DIR}/${OUT_SUB_DIR}
DATA_OUT=${DATA_OUT_DIR}/${OUT_PRE}

echo ${DATA_IN}
echo ${DATA_OUT}

${EXEC} -hostfile ${FHOST} ${APP} --graph ${DATA_IN} --format snap --iterations ${ITERS} --ncpus=${NP} --saveprefix ${DATA_OUT}
