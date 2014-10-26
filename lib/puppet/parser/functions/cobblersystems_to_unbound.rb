#  Copyright 2014 Brainsware
#
#  Licensed under the Apache License, Version 2.0 (the "License");
#  you may not use this file except in compliance with the License.
#  You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
#  Unless required by applicable law or agreed to in writing, software
#  distributed under the License is distributed on an "AS IS" BASIS,
#  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#  See the License for the specific language governing permissions and
#  limitations under the License.

#
# cobblersystems to unbound transformation
#

# takes an Hash of cobblersystems and transforms them to a Hash of unbound record hashes

module Puppet::Parser::Functions
  newfunction(:cobblersystems_to_unbound,
    :type  => :rvalue,
    :arity => 1,
    :doc   => 'takes an Hash of cobblersystems and transforms them to a Hash of unbound record hashes'
  ) do |arguments|

    input = arguments[0]
    output = {}

    get_ip = lambda { |data, key| data['interfaces']['eth0'][key] }

    raise(TypeError, "cobblersystems_to_unbound(): first argument must be a Hash. " +
          "Given an argument of class #{input.class}.") unless input.is_a? Hash

    input.each do |host, data|
      hostname = data['hostname'] || host

      output[hostname] = {
        'ip'   => get_ip[data, 'ip_address'],
        'ipv6' => get_ip[data, 'ipv6_address']
      }
    end

    output
  end
end

# vim: set ts=2 sw=2 et :

