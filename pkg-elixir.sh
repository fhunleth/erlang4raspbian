#!/bin/sh

# Create a Raspbian package for Elixir

set -e

ELIXIR_VERSION=1.4.4

# Debian package fields
MAINTAINER="Frank Hunleth <fhunleth@troodon-software.com>"
DESCRIPTION="Elixir functional meta-programming language"
LICENSE="Apache-2.0"
HOMEPAGE="http://www.elixir-lang.org/"
PKGNAME=rpi-elixir

# Remove our package if it was already installed
sudo apt remove -qq $PKGNAME || true

# Clone Elixir if this is the first time
BASEDIR=$PWD
if [ ! -d elixir ]; then
    git clone https://github.com/elixir-lang/elixir.git
    cd $BASEDIR/elixir
else
    cd $BASEDIR/elixir
    git fetch
fi

# Clean up previous builds and sync to the tag.
git reset --hard
git clean -fdx
git checkout v$ELIXIR_VERSION

# Output directories
INSTALL_DIR=$PWD/o/staging

# Build
make
make install PREFIX=/usr DESTDIR=$INSTALL_DIR

# Package
fpm -s dir -t deb -v $ELIXIR_VERSION -n $PKGNAME \
    -m "$MAINTAINER" --license "$LICENSE" \
    --description "$DESCRIPTION" \
    --url "$HOMEPAGE" --vendor "vendor" \
    --depends "rpi-erlang (>= 19.0.0)" \
    --deb-priority optional --category contrib -a all \
    -C $INSTALL_DIR

mv -f *.deb $BASEDIR

echo Success!!!
