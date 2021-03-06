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

# == Class: kvmhost
#
# This class is the global hook for installation and configuration of a
# kvmhost. It installs and configures installs and configures cobbler.
#
# === Parameters
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
# Copyright 2014 Brainsware
#
class kvmhost (
  $root_key_private = undef,
  $root_key_public  = undef,
  $export_dns       = true,
){
  contain '::cobbler'

  # this is needed for powerr management!
  package { 'fence-agents':
    ensure => latest,
  }
  # this is needed for dhcp/pxe.
  package { 'dnsmasq':
    ensure => latest,
  }

  file { '/var/lib/cobbler/kickstarts/internal.cfg':
    content => template('kvmhost/internal.cfg.erb'),
    require => Class[::cobbler],
  }
  file { '/var/lib/cobbler/kickstarts/external.cfg':
    content => template('kvmhost/external.cfg.erb'),
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/post-provision.sh':
    source  => 'puppet:///modules/kvmhost/post-provision.sh',
    mode    => '0755',
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/vm_parent.txt':
    content => "vm_parent=${::fqdn}\n",
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/resolv.internal.conf':
    source  => "puppet:///modules/${module_name}/resolv.internal.conf",
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/resolv.external.conf':
    source  => "puppet:///modules/${module_name}/resolv.external.conf",
    require => Class[::cobbler],
  }

  file { '/root/.ssh':
    ensure => directory,
    mode   => '0700',
    owner  => 'root',
    group  => 'root',
  }
  file { '/root/.ssh/id_rsa':
    content => $::kvmhost::root_key_private,
    require => File['/root/.ssh'],
  }
  file { [
    '/root/.ssh/id_rsa.pub',
    '/root/.ssh/authorized_keys',
  ]:
    content => $::kvmhost::root_key_public,
    require => File['/root/.ssh'],
  }
  file { '/srv/www/cobbler/ks_mirror/config/root_id_rsa':
    source  => '/root/.ssh/id_rsa',
    mode    => '0664',
    require => [
      File['/root/.ssh/id_rsa'],
      Class[::cobbler],
    ],
  }
  file { '/srv/www/cobbler/ks_mirror/config/root_id_rsa.pub':
    source  => '/root/.ssh/id_rsa.pub',
    mode    => '0664',
    require => [
      File['/root/.ssh/id_rsa.pub'],
      Class[::cobbler],
    ],
  }
  file { '/srv/www/cobbler/ks_mirror/config/r10k.yaml':
    source  => '/etc/puppetlabs/r10k/r10k.yaml',
    mode    => '0664',
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/ssh_known_hosts':
    source  => '/etc/ssh/ssh_known_hosts',
    mode    => '0664',
    require => Class[::cobbler],
  }

  $cobblerdistros  = hiera_hash('cobblerdistros',         {})
  $distro_defaults = hiera_hash('cobblerdistro_defaults', {})
  create_resources('cobblerdistro', $cobblerdistros, $distro_defaults)

  $cobblerprofiles  = hiera_hash('cobblerprofiles',         {})
  $profile_defaults = hiera_hash('cobblerprofile_defaults', {})
  create_resources('cobblerprofile', $cobblerprofiles, $profile_defaults)

  $cobblersystems  = hiera_hash('cobblersystems',         {})
  $system_defaults = hiera_hash('cobblersystem_defaults', {})
  $merged_systems  = resources_deep_merge($cobblersystems, $system_defaults)
  create_resources('cobblersystem', $merged_systems)

  if $export_dns {
    $dns_records = cobblersystems_to_unbound($cobblersystems)
    create_resources('@@unbound::record', $dns_records)
  }

  Class[::cobbler] -> Cobblerdistro <| |> -> Cobblerprofile <| |> -> Cobblersystem <| |>
}
