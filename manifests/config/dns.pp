# exports our systems' DNS config
define kvmhost::config::dns (
  $ip,
  $ipv6,
  $dns  = $title,
){


  @@unbound::record { "${dns}-ipv4":
    name    => $dns,
    content => $ip,
    reverse => true,
  }
  @@unbound::record { "${dns}-ipv6":
    name    => $dns,
    type    => 'AAAA',
    content => $ipv6,
    reverse => true,
  }
}
