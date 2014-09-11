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

# == Class: kvmhost::libvirt
#
# This class is the private class for installation and configuration of libvirt
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2014 Brainsware
#
class kvmhost::libvirt {

  class { '::libvirt':
    virtinst           => true,
    radvd              => true,
    unix_sock_group    => 'libvirtd',
    unix_sock_rw_perms => '0770',
    auth_unix_ro       => 'none',
    auth_unix_rw       => 'none',
  }


  $networks         = hiera('libvirt::networks',         {})
  $network_defaults = hiera('libvirt::network_defaults', {})
  create_resources('libvirt::network', $networks, $network_defaults)

  $pools         = hiera('libvirt::pools',         {})
  $pool_defaults = hiera('libvirt::pool_defaults', {})
  create_resources('libvirt_pool', $pools, $pool_defaults)
}
