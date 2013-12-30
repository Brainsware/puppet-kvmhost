#
# cobblersystems to unbound transformation
#

# takes an Hash of cobblersystems and transforms them to a Hash of unbound record hashes

module Puppet::Parser::Functions
  newfunction(:cobblersystems_to_unbound, :type => :rvalue, :doc => <<-EOS
  takes an Hash of cobblersystems and transforms them to a Hash of unbound record hashes
  EOS
  ) do |arguments|

    if (arguments.size != 1) then
      raise(Puppet::ParseError, "cobblersystems_to_unbound(): Wrong number of arguments "+
            "given #{arguments.size} for 1.")
    end

    input = arguments[0]
    output = {}

    get_ip = lambda { |data, key| data['interfaces']['eth0'][key] }

    raise(TypeError, "cobblersystems_to_unbound(): first argument must be a Hash. " +
          "Given an argument of class #{input.class}.") unless input.is_a? Hash

    input.each do |host, data|
      hostname = data['hostname'] || host

      output[hostname] = {
        'ip'   => get_ip.call[data, 'ip_address'],
        'ipv6' => get_ip.call[data, 'ipv6_address']
      }
    end

    output
  end
end

# vim: set ts=2 sw=2 et :

