#!/usr/bin/env bash
repo_workdir=/tmp/ansible-setup

# wait for reliable internet connection
failed=1
while [ $failed -ne 0 ]
do
  ping -c 1 8.8.8.8 > /dev/null 2>&1
  failed=$?
  echo "Waiting for Internet connection being ready..."
  sleep 1
done

# Install required OS dependencies
yum -y install "@Base" adcli at bind-utils bzip2 chrony dnf-utils dos2unix iotop iptraf-ng krb5-workstation \
                       lftp lsscsi ncurses-compat-libs net-snmp net-snmp-libs net-snmp-utils net-tools nmap \
                       oddjob oddjob-mkhomedir open-vm-tools open-vm-tools-desktop openldap-clients perl \
                       perl-Compress-Raw-Bzip2 perl-Compress-Raw-Zlib perl-Date-Manip perl-Digest-SHA perl-IO-Compress \
                       perl-libs perl-LWP-Protocol-https perl-Sys-Syslog procps psmisc python3-libselinux python3-PyMySQL \
                       redhat-lsb rsync samba-common samba-common-tools sysstat tcpdump telnet tigervnc-server traceroute \
                       unzip vim vsftpd wget yum-utils zip

yum -y install httpd
systemctl start httpd
systemctl enable httpd


