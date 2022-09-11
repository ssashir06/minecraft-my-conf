#!/bin/sh

export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get -y upgrade && apt-get clean && reboot
