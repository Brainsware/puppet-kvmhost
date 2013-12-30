# exports our systems' DNS config
define kvmhost::config::dns (
  $hostname   = $title,
  $ip,
  $ipv6,
){

  @@unbound::record { "${::fqdn}-ipv4":
    name    => $::fqdn,
    content => $ip,
    reverse => true,
  }
  @@unbound::record { "${::fqdn}-ipv6":
    name    => $::fqdn,
    type    => 'AAAA',
    content => $ipv6,
    reverse => true,
  }
}
