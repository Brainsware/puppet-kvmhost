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
