# To be sourced by various scripts

export DISTROS="osx-10.7-x86_64 osx-10.8-x86_64 rhel-6-x86_64"
export REPO=git@git.lsstcorp.org:contrib/lsst_distrib_tool.git
export PKGDIR="/lsst/home/lsstsw/distrib/default/www/lsst_distrib_tool"
export RELEASE_TAG=v6_1
export DISTRIB_TOOL_TAG=0.2
export DISTURL="moya.dev.lsstcorp.org:/var/www/html/dmstack/binaries"

export DISTRIB_TOOL_VER="${DISTRIB_TOOL_TAG}+1"

sw() { ssh -CYA lsstsw@lsst-dev.ncsa.illinois.edu "$@"; }
