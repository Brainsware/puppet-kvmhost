#!/bin/bash
apt-get update
apt-get install -yy -f linux-generic-lts-saucy-eol-upgrade
while ! /opt/bw/bin/puppet agent -t --waitforcert 120 --debug ; do
	# run puppet as often as necessary before the host is setup
	sleep 1
done
# When we're done, we can reboot, and everything's perfect.
reboot
