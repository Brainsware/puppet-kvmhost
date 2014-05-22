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

# == Class: kvmhost::install::cobbler
#
# This class is the global hook for installation
#
# === Parameters
#
# Inherits from kvmhost, so the same as kvmhost.
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
class kvmhost::install::cobbler inherits kvmhost{

  # this is needed for powerr management!
  package { 'fence-agents':
    ensure => latest,
  }

  # Managing the apache installation on this server
  # now happens in hiera's kvmhost role!

  # However, we secure it here by only listening to private interfaces:
  apache::listen {[
      '192.168.122.1:80',
      '127.0.0.1:80',
    ]:
  }

  # With those basics in place, we can get started with cobbler:
  class { '::cobbler':
    service_name     => 'cobblerd',
    webroot          => '/srv/www/cobbler',
    distro_path      => '/srv/www/cobbler/ks_mirror',
    server_ip        => '192.168.122.1',
    next_server_ip   => '192.168.122.1',
    allow_access     => '192.168.122.1 127.0.0.1',
    defaultrootpw    => $::kvmhost::defaultrootpw,
    dependency_class => '::cobbler::dependency',
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
}
