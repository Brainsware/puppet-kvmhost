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

# == Class: kvmhost::network
#
# Put the main interface of kvmhost into bridge mode
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
# Copyright 2014 Brainsware
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
