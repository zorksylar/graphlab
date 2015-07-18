#!/bin/bash

# --------------------------------------------------#
# Env Setup
# --------------------------------------------------#
EXEC=/home/zork/loclib/mpich-3.1.4/bin/mpiexec
export LD_LIBRARY_PATH=/home/zork/loclib/mpich-3.1.4/lib/

# -------------------------------------------------#
# Function Defines
# -------------------------------------------------#
function print_help {
  echo "Usage : "
  echo " --node=<node>                    number of machines "
  echo " --np=<np>                        number of processors "
  echo " --niters=<niters>                nubmer of iterations "
  echo " --graph=<graph_name>             graph name [nf, ]"
  echo " --als_d=<als nlatent>            number of latent "
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
    --d=*)              als_d=${1##--als_d=} ;;
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
k_niters=18446744073709551615
s_graph=nf
k_als_d=20



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

if [[ -n $als_d ]] ; then
  k_als_d=$als_d
fi

# -------------------#
# Graphs 
# -------------------#

GRAPH_PREFIX=""
OUT_DIR=""
OUT_PREFIX=""

if [ $s_graph == "nf" ] ; then
  GRAPH_PREFIX=/home/zork/data/nf/glab_in/nf.snap
  OUT_DIR=/home/zork/data/nf/glab_${k_node}_out
else 
  unknown_graph $s_graph 
fi

mkdir -p ${OUT_DIR}

OUT_PREFIX=${OUT_DIR}/${s_graph}_${k_als_d}_${k_niters}

APP=/home/zork/dev-pla/graphlab/release/toolkits/collaborative_filtering/als

# Pagerank ops
APP_OPTS="--matrix ${GRAPH_PREFIX}"
APP_OPTS="$APP_OPTS --ncpus ${k_np}"
APP_OPTS="$APP_OPTS --max_iter ${k_niters}"
APP_OPTS="$APP_OPTS --predictions ${OUT_PREFIX}"

echo "======================="
echo ${APP_OPTS}
echo "======================="

${EXEC} -hostfile ./conf/machines_${k_node} ${APP} ${APP_OPTS}


