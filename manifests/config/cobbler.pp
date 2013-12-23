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

    $names = delete_array ($cobblersystems, ['profile', 'virt_ram', 'virt_cpus', 'gateway'])
    create_resources('kvmhost::config::dns', $names, {})
  }
}

