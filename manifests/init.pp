# == Class: kvmhost
#
# This class is the global hook for installation and configuration of a
# kvmhost. It installs and configures libvirt & installs and configures cobbler.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost {
  include kvmhost::install
}
