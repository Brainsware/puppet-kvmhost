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
  $profiledefaults = {
    'nameservers'    => [ '176.9.94.130', '213.133.99.99', '213.133.100.100' ],
    'virt_path'      => 'vg0',
    'virt_file_size' => '80',
    'virt_type'      => 'kvm',
    'virt_auto_boot' => true,
    'repos'          => [],
    'search'         => [  'esat.' ],
  }
  create_resources('cobblerprofile', $cobblerprofiles, $profiledefaults)

  $cobblersystems = hiera('cobblersystems', {})
  $systemdefaults = { 'power_type' => 'virsh' }
  create_resources('cobblersystem', $cobblersystems, $systemdefaults)
}
