#!/bin/sh

# Running:
#  1. Make sure that the current user has passwordless sudo access
#  2. Run `nohup ./pkg-all.sh &` so that you can log off

# Build and package up Erlang
./pkg-erlang.sh

# Building Elixir requires Erlang to be installed, so install it now.
sudo dpkg -i otp/*.deb
./pkg-elixir.sh

