#platform=x86, AMD64, or Intel EM64T
#version=DEVEL
# Install OS instead of upgrade
install
# Keyboard layouts
keyboard 'us'
# Root password
# rootpw --plaintext password

# System language
lang en_US
# System authorization information
auth  --useshadow  --passalgo=sha512
# Use CDROM installation media
cdrom
# Use graphical install
graphical
firstboot --disable
# SELinux configuration
selinux --disabled

# Firewall configuration
firewall --disabled
# Network information
# network  --bootproto=static --device=eth0 --gateway=192.168.1.254 --ip=192.168.1.1 --nameserver=1.1.1.1 --netmask=255.255.255.0 --hostname=centos-001
# Reboot after installation
reboot
# System timezone
timezone Asia/Singapore
# System bootloader configuration
bootloader --location=mbr
# Clear the Master Boot Record
zerombr
# Partition clearing information
clearpart --all --initlabel

# Disk partitioning information
part / --fstype="xfs" --grow --size=1
part swap --fstype="swap" --recommended
part /boot --fstype="xfs" --size=1024

%packages
@^Infrastructure Server
%end

