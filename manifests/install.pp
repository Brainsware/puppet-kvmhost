# == Class: kvmhost::install
#
# This class is the global hook for installation
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost::install'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::install {
  include 'libvirt'
  include 'cobbler'

  anchor { 'start': } ->
  class { 'libvirt': } ->
  class { 'cobbler':
    webroot        => '/srv/web/cobbler',
    server_ip      => '192.168.122.1',
    next_server_ip => '192.168.122.1',
  } ->
  anchor { 'end': }
}
