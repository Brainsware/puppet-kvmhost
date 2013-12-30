# exports our systems' DNS config
define kvmhost::config::dns (
  $ip,
  $ipv6,
  $name = $title,
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
