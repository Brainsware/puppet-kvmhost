# exports our systems' DNS config
define kvmhost::config::dns (
  $hostname   = $title,
  $interfaces = [{}],
){
  validate_array($interfaces)
  validate_hash($interfaces[0])
  validate_ip($interfaces[0]['eth0']['ip_address'])
  validate_ip($interfaces[0]['eth0']['ipv6_address'])

  @@unbound::record { "${::fqdn}-ipv4":
    name    => $::fqdn,
    content => $interfaces[0]['eth0']['ipv6_address'],
    reverse => true,
  }
  @@unbound::record { "${::fqdn}-ipv6":
    name    => $::fqdn,
    type    => 'AAAA',
    content => $interfaces[0]['eth0']['ipv6_address'],
    reverse => true,
  }
}
