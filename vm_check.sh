#!/bin/bash

# [2023020501]
#
# script to check VM states

echo
echo virsh list --title
virsh list --title

echo
echo virsh list --autostart --all --title
virsh list --title --autostart --all

echo
echo virsh list --all --title
virsh list --all --title

