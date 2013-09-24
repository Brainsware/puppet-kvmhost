# == Class: kvmhost::install::cobbler
#
# All this class needs to do is include cobbler, since that's already nicely
# encapsulated.
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost::install::cobbler'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::install::cobbler {
  include cobbler
}
