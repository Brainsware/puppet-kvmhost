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

    collection = arguments[0]

    raise(TypeError, "cobblersystems_to_unbound(): first argument must be a Hash. " +
          "Given an argument of class #{collection.class}.") unless collection.is_a? Hash

    collection.each do |item|

    end
    collection
  end
end

# vim: set ts=2 sw=2 et :

