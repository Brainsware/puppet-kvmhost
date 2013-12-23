#
# delete_rb.rb
#

# takes an array as 

module Puppet::Parser::Functions
  newfunction(:delete, :type => :rvalue, :doc => <<-EOS
Deletes all instances of a given element from an array, substring from a
string, or key from a hash.

*Examples:*

    delete_array(['a','b','c','b'], ['b', 'a'])
    Would return: ['c']

    delete_array({'a'=>1,'b'=>2,'c'=>3}, ['b', 'a'])
    Would return: {'c'=>3}

    delete_array('abracadabra', ['bra'])
    Would return: 'acada'
    EOS
  ) do |arguments|

    if (arguments.size != 2) then
      raise(Puppet::ParseError, "delete_array(): Wrong number of arguments "+
        "given #{arguments.size} for 2.")
    end

    collection = arguments[0]
    items = arguments[1]

    
            
    raise(TypeError, "delete_array(): Second argument must be an Array. " +
      "Given an argument of class #{items.class}.") unless items == Array

    case collection
    when Array, Hash
      items.each do |item|
        collection.delete item
      end
    when String
      items.each do |item|
        collection.gsub! item, ''
      end
    else
      raise(TypeError, "delete(): First argument must be an Array, " +
            "String, or Hash. Given an argument of class #{collection.class}.")
    end
    collection
  end
end

# vim: set ts=2 sw=2 et :
