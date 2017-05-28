This repository will contain scripts for building up-to-date Erlang and Elixir
packages for Raspbian.

# Using these packages

On your Raspberry Pi, run the following:

```
# Tell apt to validate and trust packages signed using this key
wget -O - http://apt.troodon-software.com/fhunleth-apt-gpg.key | sudo apt-key add -

# Tell apt where the packages are
echo "deb http://apt.troodon-software.com/ jessie main" | sudo sh -c "cat > /etc/apt/sources.list.d/troodonsw.list"

# Refresh the apt database
sudo apt-get update

# Install Elixir!
sudo apt-get install rpi-elixir
```

# Notes

This link was extremely helpful:

https://scotbofh.wordpress.com/2011/04/26/creating-your-own-signed-apt-repository-and-debian-packages/

