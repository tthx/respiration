#!/bin/bash
set -euo pipefail;

ginkgo_polyhedral_restore() {
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE}")")";
  . "${script_dir}/build-env.sh";
  local src_dir="${src_home}/iCube/ginkgo";
  local dst_dir="${ginkgo_polyhedral_src_dir}";
  cp -f "${src_dir}/benchmark/run_all_benchmarks.sh" \
    "${dst_dir}/benchmark/.";
  cp -f "${src_dir}/reference/matrix/dense_kernels.cpp" \
    "${dst_dir}/reference/matrix/.";
  cp -f "${src_dir}/reference/solver/cg_kernels.cpp" \
    "${dst_dir}/reference/solver/.";
  #cp -f "${src_dir}/reference/CMakeLists.txt" \
    #"${dst_dir}/reference/.";
  cp -f "${src_dir}/common/unified/matrix/dense_kernels.template.cpp" \
    "${dst_dir}/common/unified/matrix/.";
  cp -f "${src_dir}/common/unified/matrix/dense_kernels.instantiate.cpp" \
    "${dst_dir}/common/unified/matrix/.";
  cp -f "${src_dir}/common/unified/solver/cg_kernels.cpp" \
    "${dst_dir}/common/unified/solver/.";
  cp -f "${src_dir}/omp/matrix/dense_kernels.cpp" \
    "${dst_dir}/omp/matrix/.";
  cp -f "${src_dir}/omp/solver/cg_kernels.cpp" \
    "${dst_dir}/omp/solver/.";
  cp -f "${src_dir}/omp/CMakeLists.txt" \
    "${dst_dir}/omp/.";
    return ${?};
}

ginkgo_polyhedral_restore  "${@}";
