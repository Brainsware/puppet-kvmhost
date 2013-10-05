# == Class: kvmhost::config::cobbler
#
# This class is the global hook for configuration of cobbler
# Here we'll setup our repos and distros and other funk!
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost::config::cobbler'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::config::cobbler {

  $cobblerdistros = hiera ('cobblerdistros', {})
  $distrodefaults = { 'destdir' => $::cobbler::distro_path }
  create_resources('cobblerdistro', $cobblerdistros, $distrodefaults)

  $cobblerprofiles = hiera('cobblerprofiles', {})
  $profiledefaults = {}
  create_resources('cobblerprofile', $cobblerprofiles, $profiledefaults)

  $cobblersystems = hiera('cobblersystems', {})
  $systemdefaults = { 'power_type' => 'virsh' }
  create_resources('cobblersystem', $cobblersystems, $systemdefaults)
}
