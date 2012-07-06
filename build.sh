#!/bin/bash

# Must be root to install packages
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi

repo_root="$(readlink -f $(dirname $0))"

# package to build, either thrift, fb303, or all.
package=$1
if [ -z $package ]; then
  package="all"
fi

thrift_repository_url="git://github.com/wmf-analytics/thrift.git"
fb303_repository_url="git://github.com/wmf-analytics/thrift-fb303.git"
scribe_repository_url="git://github.com/wmf-analytics/scribe.git"
scribe_log4j_repository_url="git://github.com/wmf-analytics/log4j-scribe-appender.git"

thrift_directory="${repo_root}/thrift"
fb303_directory="${repo_root}/thrift-fb303"
scribe_directory="${repo_root}/scribe"
scribe_log4j_directory="${repo_root}/log4j-scribe-appender"


function clone_repository
{
    url=$1
    dir=$2
  
    git clone $url $dir
}


function build_package {
  dir=$1

  cd $dir
  dpkg-buildpackage

  cd ..
  echo -e "\nBuilt these .deb files:\n"
  ls ./*.deb
}


function build_thrift
{
  echo -e "\nBuilding thrift packages...\n"


  if [ ! -d $thrift_directory/.git ]; then
    echo "Cloning thrift repository from $thrift_repository_url"
    clone_repository $thrift_repository_url $thrift_directory
  fi

  build_package $thrift_directory
  # This should build:
  # - libthrift0
  # - libthrift-dev
  # - libthrift-java
  # - libthrift-perl
  # - libthrift-ruby
  # - php5-thrift
  # - python-thrift
  # - python-thrift-dbg
  # - thrift-compiler

  echo -e "\nMoving packages into deb/ directory.\n"
  
  mkdir -p deb
  mv -v \
    ${repo_root}/libthrift0*.deb           \
    ${repo_root}/libthrift-dev*.deb        \
    ${repo_root}/libthrift-java*.deb       \
    ${repo_root}/libthrift-perl*.deb       \
    ${repo_root}/libthrift-ruby*.deb       \
    ${repo_root}/php5-thrift*.deb          \
    ${repo_root}/python-thrift-dbg*.deb    \
    ${repo_root}/python-thrift*.deb        \
    ${repo_root}/thrift*.changes           \
    ${repo_root}/thrift*.dsc               \
    ${repo_root}/thrift*.tar.gz            \
    ${repo_root}/thrift-compiler*.deb      \
    ${repo_root}/deb/

  echo -e "\nDone building thrift packages.\n"
}

function build_fb303
{
  ## Build thrift-fb303 packages
  # We need to install libthrift0, libthrift-dev, thrift-compiler, 
  # and python-thrift in order to compile fb303.  Go ahead and install
  # these from the newly created debs.
  echo -e "\nInstalling newly created debs for libthrift0, libthrift-dev, thrift-compiler, libthrift-java and python-thrift in order to create fb303 packages.\n"
  # uninstall these packages first
  dpkg -r libthrift0 thrift-compiler libthrift-dev python-thrift libthrift-java
  dpkg -i ${repo_root}/deb/{libthrift0,thrift-compiler,libthrift-dev,python-thrift,libthrift-java}*.deb || (echo "Could not install dependencies for fb303 packages." && exit 1)
  
  echo -e "\nBuilding fb303 packages...\n"

  if [ ! -d $fb303_directory/.git ]; then
    echo "Cloning fb303 repository from $fb303_repository_url"
    clone_repository $fb303_repository_url $fb303_directory
  fi

  build_package $fb303_directory
	# This should build:
	# - python-fb303
	# - libfb303-java
	# - thrift-fb303

  echo -e "\nMoving packages into deb/ directory.\n"
  mkdir -p deb
  mv -v \
    ${repo_root}/libfb303-java*.deb        \
    ${repo_root}/python-fb303*.deb         \
    ${repo_root}/thrift-fb303*.deb         \
    ${repo_root}/thrift-fb303*.changes     \
    ${repo_root}/thrift-fb303*.dsc         \
    ${repo_root}/thrift-fb303*.gz          \
    ${repo_root}/deb/

  echo -e "\nDone building fb303 packages.\n"
}

function build_scribe
{
  ## Build scribe packages
  # We need to install libthrift0, libthrift-dev, thrift-compiler, 
  # and python-thrift in order to compile fb303.  Go ahead and install
  # these from the newly created debs.
  echo -e "\nInstalling newly created debs for libthrift0, libthrift-dev, thrift-compiler, libthrift-java, thrift-fb303 and libfb303-java in order to create scribe packages.\n"
  # uninstall these packages first
  dpkg -r libthrift0 thrift-compiler libthrift-dev thrift-fb303 libthrift-java libfb303-java
  dpkg -i ${repo_root}/deb/{libthrift0,thrift-compiler,libthrift-dev,thrift-fb303,libthrift-java,libfb303-java}*.deb || (echo "Could not install dependencies for scribe packages." && exit 1)
  
  echo -e "\nBuilding scribe packages...\n"

  if [ ! -d $scribe_directory/.git ]; then
    echo "Cloning scribe repository from $scribe_repository_url"
    clone_repository $scribe_repository_url $scribe_directory
  fi

  build_package $scribe_directory
	# This should build:
	# - scribe
	# - libscribe-java

  echo -e "\nMoving packages into deb/ directory.\n"
  mkdir -p deb
  mv -v \
    ${repo_root}/libscribe-java*.deb  \
    ${repo_root}/scribe*.deb           \
    ${repo_root}/scribe*.changes       \
    ${repo_root}/scribe*.dsc           \
    ${repo_root}/scribe*.tar.gz        \
    ${repo_root}/deb/

  echo -e "\nDone building scribe packages.\n"
}

function build_scribe_log4j
{
  ## Build scribe packages
  # We need to install libthrift0, libthrift-dev, thrift-compiler, 
  # and python-thrift in order to build scribe-log4j.jar.  Go ahead and install
  # these from the newly created debs.
  echo -e "\nInstalling newly created debs for libthrift0, libthrift-dev, thrift-compiler, libthrift-java, thrift-fb303, libfb303-java, scribe and libscribe-java in order to create scribe-log4j-java package.\n"
  # uninstall these packages first
  dpkg -r libthrift0 thrift-compiler libthrift-dev thrift-fb303 libthrift-java libfb303-java scribe libscribe-java libscribe-log4j-java
  dpkg -i ${repo_root}/deb/{libthrift0,thrift-compiler,libthrift-dev,thrift-fb303,libthrift-java,libfb303-java,scribe,libscribe-java}*.deb || (echo "Could not install dependencies for scribe-log4j-java packages." && exit 1)
  
  echo -e "\nBuilding scribe-log4j package...\n"

  if [ ! -d $scribe_log4j_directory/.git ]; then
    echo "Cloning scribe repository from $scribe_log4j_repository_url"
    clone_repository $scribe_log4j_repository_url $scribe_log4j_directory
  fi

  build_package $scribe_log4j_directory
	# This should build:
	# - libscribe-log4j-java

  echo -e "\nMoving packages into deb/ directory.\n"
  mkdir -p deb
  mv -v \
    ${repo_root}/libscribe-log4j-java*.deb           \
    ${repo_root}/libscribe-log4j-java*.changes       \
    ${repo_root}/libscribe-log4j-java*.dsc           \
    ${repo_root}/libscribe-log4j-java*.tar.gz        \
    ${repo_root}/deb/

  echo -e "\nDone building scribe packages.\n"
}

case $package in
  thrift )
    echo "Building thrift packages"
    build_thrift 
    ;;
  fb303 )
    echo "Building fb303 packages"
    build_fb303 
    ;;
  scribe )
    echo "Building scribe packages"
    build_scribe
    ;;
  log4j )
    echo "Building scribe-log4 package"
    build_scribe_log4j
    ;;
  all )
    echo "Building thrift and fb303 packages"
    build_thrift
    build_fb303
    build_scribe
    ;;
  * ) echo -e "\n  Usage: $0 thrift|fb303|scribe|log4j|all     (Default: all)" && exit 1
    ;;
esac

exit 0
