#!/bin/bash
export LD_LIBRARY_PATH=/home/zork/loclib/mpich-3.1.4/lib/
export GRAPHLAB_SUBNET_ID=10.0.0.0
export GRAPHLAB_SUBNET_MASK=255.255.255.0

DATA_DIR=/home/zork/data/web-google
IN_NAME=web-google.txt
OUT_SUB_DIR=graphlab_4_out
OUT_PRE=wg

ITERS=1
NP=1
OUT_PRE="${OUT_PRE}_${ITERS}"

EXEC=/home/zork/loclib/mpich-3.1.4/bin/mpiexec
APP=/home/zork/dev-pla/graphlab/release/toolkits/graph_analytics/pagerank
#FHOST=/home/zork/dev-pla/graphlab/zscript/conf/machines_4
FHOST=/home/zork/dev-pla/graphlab/zscript/conf/machines_ipoib_4

DATA_IN=${DATA_DIR}/${IN_NAME}
DATA_OUT_DIR=${DATA_DIR}/${OUT_SUB_DIR}
DATA_OUT=${DATA_OUT_DIR}/${OUT_PRE}

mkdir -p ${DATA_OUT_DIR}

echo ${DATA_IN}
echo ${DATA_OUT}
${EXEC} -hostfile ${FHOST} ${APP} --graph ${DATA_IN} --format snap --iterations ${ITERS} --ncpus=${NP} --saveprefix ${DATA_OUT}
