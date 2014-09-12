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

# == Class: kvmhost::cobbler
#
# This is the private class for installing / configuring cobbler
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::cobbler {

  # this is needed for powerr management!
  package { 'fence-agents':
    ensure => latest,
  }

  # With those basics in place, we can get started with cobbler:
  class { '::cobbler':
    service_name     => 'cobblerd',
    webroot          => '/srv/www/cobbler',
    distro_path      => $::kvmhost::cobbler_destdir,
    defaultrootpw    => $::kvmhost::defaultrootpw,
  }

  file { '/srv/www/cobbler/ks_mirror/config/internal.cfg':
    content => template('kvmhost/internal.cfg.erb'),
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/external.cfg':
    content => template('kvmhost/external.cfg.erb'),
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/puppet.conf':
    source  => 'puppet:///modules/kvmhost/puppet.conf',
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/post-provision.sh':
    source  => 'puppet:///modules/kvmhost/post-provision.sh',
    mode    => '0755',
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/vm_parent.txt':
    content => "vm_parent=${::fqdn}",
    require => Class[::cobbler],
  }
  file { '/srv/www/cobbler/ks_mirror/config/resolv.conf':
    ensure  => link,
    target  => '/etc/resolv.conf',
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
    require => [
      Class[::cobbler],
      File['/root/.ssh'],
    ],
  }
  file { '/root/.ssh/id_rsa.pub':
    content => $::kvmhost::root_key_public,
    require => [
      Class[::cobbler],
      File['/root/.ssh'],
    ],
  }
  file { '/srv/www/cobbler/ks_mirror/config/root_id_rsa':
    source  => '/root/.ssh/id_rsa',
    require => File['/root/.ssh/id_rsa'],
  }
  file { '/srv/www/cobbler/ks_mirror/config/root_id_rsa.pub':
    source  => '/root/.ssh/id_rsa.pub',
    require => File['/root/.ssh/id_rsa.pub'],
  }

  $cobblerdistros  = hiera('cobblerdistros',         {})
  $distro_defaults = hiera('cobblerdistro_defaults', {})
  create_resources('cobblerdistro', $cobblerdistros, $distro_defaults)

  $cobblerprofiles  = hiera('cobblerprofiles',         {})
  $profile_defaults = hiera('cobblerprofile_defaults', {})
  create_resources('cobblerprofile', $cobblerprofiles, $profile_defaults)

  $cobblersystems  = hiera('cobblersystems',         {})
  $system_defaults = hiera('cobblersystem_defaults', {})
  create_resources('cobblersystem', $cobblersystems, $system_defaults)
}
