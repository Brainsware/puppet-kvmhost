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

require 'spec_helper_system'

describe 'kvmhost class' do
  case node.facts['osfamily']
  when 'RedHat'
    package_name = [ 'libvirt', 'cobbler' ]
    service_name = [ 'libvirtd', 'cobblerd' ]
  when 'Debian'
    package_name = [ 'libvirt-bin', 'cobblerd' ]
    service_name = [ 'libvirt-bin', 'cobblerd' ]
  end

  context 'default parameters' do
    # Using puppet_apply as a helper
    it 'should work with no errors' do
      pp = <<-EOS
      class { 'kvmhost': }
      EOS

      # Run it twice and test for idempotency
      puppet_apply(pp) do |r|
        r.exit_code.should_not == 1
        r.refresh
        r.exit_code.should be_zero
      end
    end

    describe package(package_name) do
      it { should be_installed }
    end
    describe service(service_name) do
      it { should be_enabled }
      it { should be_running }
    end

  end
end
