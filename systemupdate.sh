#!/bin/sh

apt-get update && apt-get -y upgrade && apt-get clean && reboot
