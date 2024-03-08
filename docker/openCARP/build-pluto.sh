#!/bin/bash
set -euo pipefail;

unpatch() {
  if [ -f "${pluto_src_dir}/pet/scan.h.orig" ];
  then
    mv -f "${pluto_src_dir}/pet/scan.h.orig" \
      "${pluto_src_dir}/pet/scan.h";
  fi
  if [ -f "${pluto_src_dir}/pet/scop_plus.h.orig" ];
  then
    mv -f "${pluto_src_dir}/pet/scop_plus.h.orig" \
      "${pluto_src_dir}/pet/scop_plus.h";
  fi
  if [ -f "${pluto_src_dir}/cloog-isl/Makefile.orig" ];
  then
    mv "${pluto_src_dir}/cloog-isl/Makefile.orig" \
      "${pluto_src_dir}/cloog-isl/Makefile";
  fi
}

build_pluto() {
  local script_dir="$(dirname "$(readlink -f "${BASH_SOURCE}")")";
  local pluto_branch="master";
  . "${script_dir}/runtime-env.sh";
  local cc="/usr/bin/gcc";
  local cxx="/usr/bin/g++";
  local cflags="${common_cflags}";
  local cxxflags="${common_cxxflags}";
  local ldflags="";
  if [ ! -d "${pluto_src_dir}" ];
  then
    git clone \
      --depth=1 \
      --recursive \
      -b "${pluto_branch}" \
      "${pluto_repo_url}" \
      "${pluto_src_dir}";
  fi
  cd "${pluto_src_dir}";
  git pull --recurse-submodules;
  rm -rf "${pluto_prefix}";
  ./autogen.sh;
  export CC="${cc}";
  export CXX="${cxx}";
  export CFLAGS="${cflags}";
  export CXXFLAGS="${cxxflags}";
  export LDFLAGS="${ldflags}";
  export LIBS="$(llvm-config --ldflags) -lclangASTMatchers -lclangSupport -lclangBasic";
  ./configure \
    --prefix="${pluto_prefix}" \
    --with-clang-prefix="$(llvm-config --prefix)" \
    --enable-glpk;
  make clean;
  unpatch;
  patch -b "${pluto_src_dir}/pet/scan.h" \
    "${src_home}/iCube/pluto/pet/scan.h.patch";
  patch -b "${pluto_src_dir}/pet/scop_plus.h" \
    "${src_home}/iCube/pluto/pet/scop_plus.h.patch";
  patch -b "${pluto_src_dir}/cloog-isl/Makefile" \
    "${src_home}/iCube/pluto/cloog-isl/Makefile.patch";
  make -j $(nproc) all;
  make test;
  make install;
  unpatch;
  cp -f "${src_home}/iCube/pluto/inscop" \
    "${pluto_prefix}/bin/.";
  cp -f "${src_home}/iCube/pluto/polycc" \
    "${pluto_prefix}/bin/.";
  return ${?};
}

build_pluto;