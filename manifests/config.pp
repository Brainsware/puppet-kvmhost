# == Class: kvmhost::config
#
# This class is the global hook for configuration
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost::config'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::config {

  class { 'kvmhost::config::cobbler': }

}
