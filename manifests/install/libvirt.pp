# == Class: kvmhost::install::libvirt
#
# This class is the global hook for installuration of libvirt
# We put it in an extra class so as to not cluster the calling one.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost::install::libvirt'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::install::libvirt {

  class { '::libvirt': }

  $dhcp = {
    start      => '192.168.122.2',
    end        => '192.168.122.254',
    bootp_file => 'pxelinux.0',
  }
  $pxe_ip = {
    'address' => '192.168.122.1',
    'prefix'  => '24',
    'dhcp'    => $dhcp,
  }
  libvirt::network { 'pxe':
    ensure       => 'enabled',
    autostart    => true,
    forward_mode => 'nat',
    ip           => [ $pxe_ip ],
  }

  libvirt::network { 'direct-net':
    ensure             => 'enabled',
    autostart          => true,
    forward_mode       => 'bridge',
    forward_dev        => 'eth0',
    forward_interfaces => [ 'eth0', ],
  }
}
