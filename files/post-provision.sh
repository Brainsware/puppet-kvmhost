#!/bin/bash
# replace resolvconf, with a file.
apt-get purge --force-yes -f resolvconf
rm -f /etc/resolv.conf
wget -P/etc http://192.168.122.1/cblr/ks_mirror/config/resolv.conf

apt-get update
apt-get install -yy -f linux-generic-lts-saucy-eol-upgrade

# remove old kernel:
dpkg -l | awk '/raring/{print $2}' | xargs apt-get purge -y

while ! /opt/bw/bin/puppet agent -t --waitforcert 30 --debug ; do
	# run puppet as often as necessary before the host is setup
	sleep 1
done
# When we're done, we can reboot, and everything's perfect.
reboot
