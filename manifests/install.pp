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
  anchor { 'start': } ->
  class { 'libvirt': } ->
  class { 'cobbler': } ->
  anchor { 'end': }
}
