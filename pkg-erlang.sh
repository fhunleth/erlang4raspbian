#!/bin/sh

# Create a Raspbian package for Erlang
#
# Running:
#  1. Make sure that the current user has passwordless sudo access
#  2. Run `nohup ./pkg-erlang.sh &` so that you can log off


set -e

export LANG=C

OTP_VERSION=19.3.1

# Debian package fields
MAINTAINER="Frank Hunleth <fhunleth@troodon-software.com>"
DESCRIPTION="Concurrent, real-time, distributed functional language"
LICENSE="Apache-2.0"
HOMEPAGE="http://www.erlang.org/"
PKGNAME=rpi-erlang

# Remove our package if it was already installed
sudo apt remove -qq $PKGNAME || true

# Make sure that the system is updated
sudo apt update -qq
sudo apt upgrade -qq

# Install required packages
#
# autoconf        - needed to run "./otp_build autoconf"
# fpm             - used to make a .deb file
# htop            - because
# libncurses5-dev - required by otp installation instructions
# libsctp-dev     - inferred from Erlang Solutions Deban package dependencies
# libssl-dev      - needed for the crypto, ssl, and ssh packages
# libwxgtk3.0-dev - needed for the wx package
# ruby-dev        - needed to run "gem install fpm"
#
sudo apt install -qq ruby-dev htop autoconf libncurses5-dev libssl-dev libwxgtk3.0-dev libsctp-dev

sudo gem install fpm

# Clone Erlang if this is the first time
cd $HOME
if [ ! -d otp ]; then
    git clone https://github.com/erlang/otp.git
fi

# Clean up previous builds and sync to the tag.
cd otp
git reset --hard
git clean -fdx
git checkout OTP-$OTP_VERSION

# Output directories
RELEASE_DIR=$PWD/o/release
INSTALL_DIR=$PWD/o/staging

# Build
export ERL_TOP=$PWD
./otp_build autoconf
./configure --prefix=/usr
make release RELEASE_ROOT=$RELEASE_DIR
make install DESTDIR=$INSTALL_DIR

# Package
# NOTE: fpm has a bug that you prevents you from specifying all of the "provides" in one
#       option.
fpm -s dir -t deb -v $OTP_VERSION -n $PKGNAME \
    -m "$MAINTAINER" --license "$LICENSE" \
    --description "$DESCRIPTION" \
    --url "$HOMEPAGE" --vendor "vendor" \
    --depends "procps" \
    --depends "libc6 (>= 2.15)" \
    --depends "libncurses5" \
    --depends "zlib1g (>=1:1.2.2)" \
    --depends "libssl1.0.0 (>=1.0.1)" \
    --depends "libgcc1 (>=1:3.0)" \
    --depends "libstdc++6" \
    --depends "libwxbase3.0-0" \
    --depends "libwxgtk3.0-0" \
    --depends "libsctp1" \
    --conflicts "erlang-base-hipe, erlang-base, erlang-dev, erlang-appmon, erlang-asn1, erlang-common-test, erlang-corba, erlang-crypto, erlang-debugger, erlang-dialyzer, erlang-docbuilder, erlang-edoc, erlang-erl-docgen, erlang-et, erlang-eunit, erlang-gs, erlang-ic, erlang-inets, erlang-inviso, erlang-megaco, erlang-mnesia, erlang-observer, erlang-odbc, erlang-os-mon, erlang-parsetools, erlang-percept, erlang-pman, erlang-public-key, erlang-reltool, erlang-runtime-tools, erlang-snmp, erlang-ssh, erlang-ssl, erlang-syntax-tools, erlang-test-server, erlang-toolbar, erlang-tools, erlang-tv, erlang-typer, erlang-webtool, erlang-wx, erlang-xmerl" \
    --replaces "erlang-base-hipe, erlang-base, erlang-dev, erlang-appmon, erlang-asn1, erlang-common-test, erlang-corba, erlang-crypto, erlang-debugger, erlang-dialyzer, erlang-docbuilder, erlang-edoc, erlang-erl-docgen, erlang-et, erlang-eunit, erlang-gs, erlang-ic, erlang-inets, erlang-inviso, erlang-megaco, erlang-mnesia, erlang-observer, erlang-odbc, erlang-os-mon, erlang-parsetools, erlang-percept, erlang-pman, erlang-public-key, erlang-reltool, erlang-runtime-tools, erlang-snmp, erlang-ssh, erlang-ssl, erlang-syntax-tools, erlang-test-server, erlang-toolbar, erlang-tools, erlang-tv, erlang-typer, erlang-webtool, erlang-wx, erlang-xmerl" \
    --provides "erlang-abi-17.0" \
    --provides "erlang-base-hipe" \
    --provides "erlang-dev" \
    --provides "erlang-appmon" \
    --provides "erlang-asn1" \
    --provides "erlang-common-test" \
    --provides "erlang-corba" \
    --provides "erlang-crypto" \
    --provides "erlang-debugger" \
    --provides "erlang-dialyzer" \
    --provides "erlang-docbuilder" \
    --provides "erlang-edoc" \
    --provides "erlang-erl-docgen" \
    --provides "erlang-et" \
    --provides "erlang-eunit" \
    --provides "erlang-gs" \
    --provides "erlang-ic" \
    --provides "erlang-inets" \
    --provides "erlang-inviso" \
    --provides "erlang-megaco" \
    --provides "erlang-mnesia" \
    --provides "erlang-observer" \
    --provides "erlang-odbc" \
    --provides "erlang-os-mon" \
    --provides "erlang-parsetools" \
    --provides "erlang-percept" \
    --provides "erlang-pman" \
    --provides "erlang-public-key" \
    --provides "erlang-reltool" \
    --provides "erlang-runtime-tools" \
    --provides "erlang-snmp" \
    --provides "erlang-ssh" \
    --provides "erlang-ssl" \
    --provides "erlang-syntax-tools" \
    --provides "erlang-test-server" \
    --provides "erlang-toolbar" \
    --provides "erlang-tools" \
    --provides "erlang-tv" \
    --provides "erlang-typer" \
    --provides "erlang-webtool" \
    --provides "erlang-wx" \
    --provides "erlang-xmerl" \
    --deb-priority optional --category interpreters -a armhf \
    -C $INSTALL_DIR

echo Success!!!
