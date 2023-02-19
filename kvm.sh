#!/bin/bash

echo
echo egrep -c '(vmx|svm)' /proc/cpuinfo
egrep -c '(vmx|svm)' /proc/cpuinfo

echo
echo kvm-ok
kvm-ok

echo
echo libvirtd --version
libvirtd --version

echo
echo virsh --version
virsh --version

echo
echo qemu-system-x86_64 --version
qemu-system-x86_64 --version

echo
echo ovs-vsctl --version
ovs-vsctl --version

echo
echo systemctl is-active libvirtd
systemctl is-active libvirtd

