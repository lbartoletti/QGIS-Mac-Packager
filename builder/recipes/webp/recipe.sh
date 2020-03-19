#!/bin/bash

# version of your package
VERSION_webp=1.1.0

# dependencies of this recipe
DEPS_webp=()

# url of the package
URL_webp=https://storage.googleapis.com/downloads.webmproject.org/releases/webp/libwebp-${VERSION_webp}.tar.gz

# md5 of the package
MD5_webp=7e047f2cbaf584dff7a8a7e0f8572f18

# default build path
BUILD_webp=$BUILD_PATH/webp/$(get_directory $URL_webp)

# default recipe path
RECIPE_webp=$RECIPES_PATH/webp

# function called for preparing source code if needed
# (you can apply patch etc here.)
function prebuild_webp() {
  cd $BUILD_webp

  # check marker
  if [ -f .patched ]; then
    return
  fi

  patch_configure_file configure

  touch .patched
}

function shouldbuild_webp() {
  # If lib is newer than the sourcecode skip build
  if [ ${STAGE_PATH}/lib/libwebp.dylib -nt $BUILD_webp/.patched ]; then
    DO_BUILD=0
  fi
}

# function called to build the source code
function build_webp() {
  try rsync -a $BUILD_webp/ $BUILD_PATH/webp/build-$ARCH/
  try cd $BUILD_PATH/webp/build-$ARCH
  push_env

  try ${CONFIGURE}

  check_file_configuration config.status
  try $MAKESMP
  try $MAKESMP install

  pop_env
}

# function called after all the compile have been done
function postbuild_webp() {
  verify_lib "${STAGE_PATH}/lib/libwebp.dylib"
}
