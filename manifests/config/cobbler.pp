#  Copyright 2014 Brainsware
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

# == Class: kvmhost::config::cobbler
#
# This class is the global hook for configuration of cobbler
# Here we'll setup our repos and distros and other funk!
#
# === Parameters
#
# inherits from kvmhost, so the same.
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
# Copyright 2014 Brainsware
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

    $names = cobblersystems_to_unbound ($cobblersystems)
    create_resources('kvmhost::config::dns', $names, {})

  }
  @@unbound::record { $::fqdn:
    content => "${kvmhost::ipv6}::10:1",
    type    => 'AAAA',
    reverse => true,
  }
}

