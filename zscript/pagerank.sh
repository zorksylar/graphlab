#!/bin/bash

# --------------------------------------------------#
# Env Setup
# --------------------------------------------------#
EXEC=/home/zork/loclib/mpich-3.1.4/bin/mpiexec
export LD_LIBRARY_PATH=/home/zork/loclib/mpich-3.1.4/lib/
#export GRAPHLAB_SUBNET_ID=10.0.0.0
#export GRAPHLAB_SUBNET_MASK=255.255.255.0

# -------------------------------------------------#
# Function Defines
# -------------------------------------------------#
function print_help {
  echo "Usage : "
  echo " --node=<node>                    number of machines "
  echo " --np=<np>                        number of processors "
  echo " --niters=<niters>                nubmer of iterations "
  echo " --graph=<graph_name>             graph name [wg, tw, live, test]"
  echo " --net=<network>                  network [1g, 10g]"
  echo ""
  exit 1
} # end of print_help

function unknown_option {
  echo "Unrecognized option : $1"
  print_help;
  exit 1
} # end of unknow option

function unknown_graph {
  echo "Unrecognized option : $1"
  print_help;
  exit 1
} # end of unknown_graph


# -------------------------------------------------#
# Parse Command Line Config 
# -------------------------------------------------#
while [ $# -gt 0 ]
  do case $1 in 
    --mem-check)        mem_check=1 ;;
    --node=*)           node=${1##--node=} ;;
    --np=*)             np=${1##--np=} ;;
    --niters=*)         niters=${1##--niters=} ;;
    --graph=*)          graph=${1##--graph=} ;;
    --net=*)            net=${1##--net=} ;;
    *) unknown_option $1 ;;
  esac
  shift
done


# -------------------------------------------------#
# Application 
# -------------------------------------------------#

# default optinos 
k_node=1
k_np=1
k_niters=10
s_graph=wg
s_net=10g


if [[ -n $node ]]; then
  k_node=$node
fi

if [[ -n $np ]] ; then
  k_np=$np
fi

if [[ -n $niters ]] ;then
  k_niters=$niters
fi

if [[ -n $graph ]] ; then
  s_graph=$graph
fi

if [[ -n $net ]] ; then
  s_net=$net
fi

# -------------------#
# Graphs 
# -------------------#

GRAPH_PREFIX=""
OUT_DIR=""
OUT_PREFIX=""

if [ $s_graph == "wg" ] ; then
  GRAPH_PREFIX=/home/zork/data/web-google/glab_in/web-google.txt
  OUT_DIR=/home/zork/data/web-google/glab_${k_node}_out

elif [ $s_graph == "tw" ]; then
  GRAPH_PREFIX=/scratch1/zork/data/twitter/glab_in/twitter_rv.net
  OUT_DIR=/scratch1/zork/data/twitter/glab_${k_node}_out
#  GRAPH_PREFIX=/home/zork/data/twitter/glab_in/twitter_rv.net
#  OUT_DIR=/home/zork/data/twitter/glab_${k_node}_out
elif [ $s_graph == "live" ]; then
  GRAPH_PREFIX=/home/zork/data/soc-live/glab_in/soc-LiveJournal1.txt
  OUT_DIR=/home/zork/data/soc-live/glab_${k_node}_out

elif [ $s_graph == "test" ]; then
  GRAPH_PREFIX=/home/zork/data/test/test.snap
  OUT_DIR=/home/zork/data/test/glab_${k_node}_out
else 
  unknown_graph $s_graph 
fi

mkdir -p ${OUT_DIR}
OUT_PREFIX=${OUT_DIR}/${s_graph}_${k_niters}

LOG_DIR=/home/zork/dev-pla/graphlab/zscript/log/
mkdir -p ${LOG_DIR}

TM=`date +"%y%m%d-%H%M%S"`


GRAPH_FORMAT=snap
APP=/home/zork/dev-pla/graphlab/release/toolkits/graph_analytics/pagerank

# Host file
if [ $s_net == "1g" ] ; then
  HOST=./conf/machines_${k_node}_1g
  export GRAPHLAB_SUBNET_ID=192.168.1.0
  export GRAPHLAB_SUBNET_MASK=255.255.255.0
elif [ $s_net == "10g" ] ; then
  HOST=./conf/machines_${k_node}_10g
  export GRAPHLAB_SUBNET_ID=10.0.0.0
  export GRAPHLAB_SUBNET_MASK=255.255.255.0
else 
  unknown_option $s_net
fi

# Log file name

LOG_FILE=pagerank_${k_node}_${k_np}_${k_niters}_${s_net}_$(basename ${GRAPH_PREFIX})_${TM}.log

# Pagerank ops
APP_OPTS="--graph ${GRAPH_PREFIX}"
APP_OPTS="$APP_OPTS --format ${GRAPH_FORMAT}"
APP_OPTS="$APP_OPTS --iterations ${k_niters}"
APP_OPTS="$APP_OPTS --ncpus ${k_np}"
APP_OPTS="$APP_OPTS --saveprefix ${OUT_PREFIX}"

echo "======================="
echo ${APP_OPTS}
echo "======================="

${EXEC} -hostfile ${HOST} ${APP} ${APP_OPTS} > ${LOG_DIR}/${LOG_FILE} 2>&1


