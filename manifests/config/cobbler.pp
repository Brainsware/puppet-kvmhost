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
class kvmhost::config::cobbler inherits kvmhost {

  $cobblerdistros = hiera ('cobblerdistros', {})
  $distrodefaults = { 'destdir' => $::cobbler::distro_path }
  if $cobblerdistros {
    create_resources('cobblerdistro', $cobblerdistros, $distrodefaults)
  }

  $cobblerprofiles = hiera('cobblerprofiles', {})
  $profiledefaults = {
    'nameservers'    => [
      '176.9.94.130', '213.133.99.99', '213.133.100.100',
      '2a01:4f8:0:a0a1::add:1010', '2a01:4f8:0:a111::add:9898', '2a01:4f8:0:a102::add:9999',
    ],
    'virt_path'      => 'vg0',
    'virt_file_size' => '80',
    'virt_type'      => 'kvm',
    'virt_auto_boot' => true,
    'repos'          => [],
    'search'         => [  'esat.' ],
  }
  if $cobblerprofiles {
    create_resources('cobblerprofile', $cobblerprofiles, $profiledefaults)
  }

  $cobblersystems = hiera('cobblersystems', {})
  $systemdefaults = {
    'power_type' => 'virsh',
    'gateway'    => '192.168.122.1',
  }

  if $cobblersystems {
    create_resources('cobblersystem', $cobblersystems, $systemdefaults)
  }
}
