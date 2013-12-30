# exports our systems' DNS config
define kvmhost::config::dns (
  $name,
  $ip,
  $ipv6,
){

  @@unbound::record { "${name}-ipv4":
    name    => $name,
    content => $ip,
    reverse => true,
  }
  @@unbound::record { "${name}-ipv6":
    name    => $name,
    type    => 'AAAA',
    content => $ipv6,
    reverse => true,
  }
}
