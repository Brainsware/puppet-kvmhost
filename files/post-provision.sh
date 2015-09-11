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

/opt/puppetlabs/puppet/bin/gem install r10k
/opt/puppetlabs/puppet/bin/r10k deploy environment -p

while ! /opt/puppetlabs/bin/puppet apply /etc/puppetlabs/code/environments/production/manifests/site.pp ; do
	# run puppet as often as necessary before the host is setup
	sleep 1
done
# When we're done, we can reboot, and everything's perfect.
reboot
