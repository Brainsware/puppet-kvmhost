# exports our systems' DNS config
define kvmhost::config::dns (
  $ip,
  $ipv6,
  $dns  = $title,
){


  @@unbound::record { "${dns}-ipv4":
    entry   => $dns,
    type    => 'A',
    content => $ip,
    reverse => true,
  }
  @@unbound::record { "${dns}-ipv6":
    entry   => $dns,
    type    => 'AAAA',
    content => $ipv6,
    reverse => true,
  }
}
