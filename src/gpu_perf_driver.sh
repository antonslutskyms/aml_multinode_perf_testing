#! /bin/bash
echo "Loading perf tests"

test_and_run_command()
{
    exec_name=$1
    command_str=$2
    hint=$3

    echo ">>> $command_str"
    
    if ! command -v $exec_name &> /dev/null
    then    
        echo "$exec_name could not be found in PATH"
        echo "hint: $hint"
    else
        eval $command_str
    fi
}

echo "=============== Checking NCCL_TOPO_FILE env variable: ==============="
ls -l $NCCL_TOPO_FILE
echo "Contents of $NCCL_TOPO_FILE:"
cat $NCCL_TOPO_FILE
echo "===================================================================="

test_and_run_command \
    printenv \
    printenv \
    "none"

test_and_run_command \
    lspci \
    lspci \
    "use 'apt install pciutils' to enable"
    
test_and_run_command \
    lstopo \
    "lstopo -v" \
    "use 'apt install hwloc' to enable"

test_and_run_command \
    nvidia-smi \
    "nvidia-smi topo -m" \
    "use 'apt install nvidia-smi' to enable"
    
test_and_run_command \
    ibstat \
    "ibstat -l" \
    "use 'apt install openib-diags' to enable"
    
test_and_run_command \
    ucx_info \
    "ucx_info -d"

test_and_run_command \
    nvcc \
    "nvcc --version"
    
test_and_run_command \
    all_reduce_perf \
    "all_reduce_perf -e 8G -f 2 -g 1" \
    "build and install https://github.com/NVIDIA/nccl-tests.git"

echo "Checking NCCL_TOPO_FILE env variable:"
ls -l $NCCL_TOPO_FILE
