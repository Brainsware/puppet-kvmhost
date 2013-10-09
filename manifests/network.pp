# == Class: kvmhost::network
#
# Put the main interface of kvmhost into bridge mode
#
# === Parameters
#
# === Variables
#
# === Examples
#
#  include 'kvmhost::network'
#
# === Authors
#
# Brainsware <puppet@brainsware.org>
#
# === Copyright
#
# Copyright 2013 Brainsware
#
class kvmhost::network inherits kvmhost {

  file { '/etc/network/interfaces':
    ensure  => file,
    content => template ('kvmhost/network_interfaces.erb'),
    notify  => Exec[networking::restart]
  }

  # call /etc/init.d/restart
  exec { 'networking::restart':
    refreshonly => true,
    provider    => 'posix',
    cwd         => '/',
    path        => '/bin:/usr/bin',
    command     => '/etc/init.d/networking restart',
  }
  
}
