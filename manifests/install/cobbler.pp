# == Class: kvmhost::install::cobbler
#
# This class is the global hook for installation
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
    service_name   => 'cobblerd',
    webroot        => '/srv/www/cobbler',
    distro_path    => '/srv/www/cobbler/ks_mirror',
    server_ip      => '192.168.122.1',
    next_server_ip => '192.168.122.1',
    allow_access   => '192.168.122.1 127.0.0.1',
    defaultrootpw  => '$6$JdSUnsX8THgmQS4$U.djCmthXU7v9DbxQLLOYbicNOa8Yy1oroFj2RDjQu/RdwVI0lXN10.48qbFNRLrBiV41vKOFu2AFf4iBUQ0t1',
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
}
