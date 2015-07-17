
DATA_DIR=/home/zork/data/web-google
IN_NAME=web-google.txt
OUT_SUB_DIR=graphlab_1_out
OUT_PRE=wg

ITERS=30
OUT_PRE="${OUT_PRE}_${ITERS}"

EXE=/home/zork/dev-pla/graphlab/release/toolkits/graph_analytics/pagerank

DATA_IN=${DATA_DIR}/${IN_NAME}
DATA_OUT_DIR=${DATA_DIR}/${OUT_SUB_DIR}
DATA_OUT=${DATA_OUT_DIR}/${OUT_PRE}

echo ${DATA_IN}
echo ${DATA_OUT}

${EXE} --graph ${DATA_IN} --format snap --iterations ${ITERS} --saveprefix ${DATA_OUT}
