#!/bin/bash

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

# set network/interfaces mutable again
chattr -i /etc/network/interfaces

# replace resolvconf, with a file.
apt-get purge --force-yes -f resolvconf

apt-get update
apt-get install -yy -f linux-generic-lts-trusty-eol-upgrade

# remove old kernel:
dpkg -l | awk '/raring|saucy|utopic/{print $2}' | xargs apt-get purge -y

/opt/puppetlabs/puppet/bin/gem install r10k hiera-file


while ! /opt/puppetlabs/puppet/bin/r10k deploy environment -p ; do
	# run r10k as often as necessary until it finishes successfully
  # because our network is super flakey D':
  sleep 1
done


while ! /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp ; do
	# run puppet as often as necessary before the host is setup
  # because puppet reconfigures our network, we'll pull it up and down as needed ;O
  ifdown eth0
  ifup eth0
done

# When we're done, we can reboot, and everything's perfect.
reboot
