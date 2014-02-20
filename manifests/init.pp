# == Class: kvmhost
#
# This class is the global hook for installation and configuration of a
# kvmhost. It installs and configures libvirt & installs and configures cobbler.
#
# === Parameters
#
# === Variables
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
# Copyright 2013 Brainsware
#
class kvmhost (
  $ip               = undef,
  $broadcast        = undef,
  $netmask          = undef,
  $gateway          = undef,
  $network          = undef,
  $bridge           = 'virbr1',
  $interface        = 'eth0',
  $ipv6             = undef,
  $ipv6_gateway     = undef,
  $defaultrootpw    = '',
  $root_key_private = undef,
  $root_key_public  = undef,
){
  unless is_ip_address($ip) {
    fail("${module_name}: ip must be a valid IP address: ${ip}")
  }
  unless is_ip_address($broadcast) {
    fail("${module_name}: broadcast must be a valid IP address: ${broadcast}")
  }
  unless is_ip_address($netmask) {
    fail("${module_name}: netmask must be a valid IP address: ${netmask}")
  }
  unless is_ip_address($network) {
    fail("${module_name}: network must be a valid IP address: ${network}")
  }
  unless is_ip_address($gateway) {
    fail("${module_name}: gateway must be a valid IP address: ${gateway}")
  }
  unless is_ip_address("${ipv6}::1") {
    fail("${module_name}: IPv6 must be a valid IPv6 address: ${ipv6}::1")
  }
  unless is_ip_address($ipv6_gateway) {
    fail("${module_name}: IPv6 Gateway must be a valid IPv6 address: ${ipv6_gateway}")
  }

  # Fill in vm_profile fact.
  file { '/etc/facter/facts.d/vm_profile.txt':
    content => 'vm_profile=kvmhost',
  }

  # export *our* network
  @@ufw::allow { "allow-from-trusted-private-${kvmhost::ipv6}::":
    from => "${kvmhost::ipv6}::/64",
    tag  => 'trusted-ipv6'
  }


  anchor { 'start-init': } ->
  class { 'kvmhost::network': } ->
  class { 'kvmhost::install': } ->
  class { 'kvmhost::config': } ->
  anchor { 'end-init': }
}
