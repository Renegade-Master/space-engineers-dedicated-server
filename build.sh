#!/usr/bin/env bash

# Set to `-x` for Debug logging
set +x -u -o pipefail

build() {
  pwd=$(pwd)
  src="${pwd}/src/run_server.go ${pwd}/src/util_server.go"
  output_dir="${pwd}/build/"

  printf "Building source files: [%s]\n" "${src}"
  printf "Using output directory: [%s]\n" "${output_dir}"

  go build \
    -o "${output_dir}" \
    "${src}"

  printf "Build Complete!\n"
}

## Main ##
build
