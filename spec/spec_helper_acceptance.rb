require 'beaker-rspec/spec_helper'
#require 'beaker-rspec/helpers/serverspec'
#require 'beaker/puppet_install_helper'

#run_puppet_install_helper unless ENV['BEAKER_provision'] == 'no' || ENV['BEAKER_set'] =~ /freebsd/

# https://github.com/puppetlabs/beaker/tree/master/docs/how_to
# https://github.com/puppetlabs/beaker-rspec
#run_puppet_install_helper
install_puppet_from_gem_on(hosts, {
  :version          => '4.10.1',
  :facter_version   => '2.4.6',
  :hiera_version    => '3.3.1',
  :default_action   => 'gem_install',
})

RSpec.configure do |c|
  # Project root
  proj_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))

  # Readable test descriptions
  c.formatter = :documentation

  # Configure all nodes in nodeset
  c.before :suite do
    hosts.each do |host|

      #install_puppet_on(host, puppet_agent_version: '1.8.3')
      #on host, 'gem install puppet'
      #on host, 'gem install facter'
      #on host, 'gem install hiera'

      puppet_module_install(source: proj_root,
                            module_name: 'xcode',
                            target_module_path: '/etc/puppetlabs/code/environments/production/modules')

      on host, puppet('module', 'install', 'puppetlabs-stdlib'), acceptable_exit_codes: [0, 1]
      on host, puppet('module', 'install', 'puppet-archive'), acceptable_exit_codes: [0, 1]
    end
  end
end
