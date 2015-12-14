require 'puppetlabs_spec_helper/module_spec_helper'

RSpec.configure do |c|
  c.mock_with :rspec

  c.before(:each) do
    Puppet::Util::Log.level = :warning
    Puppet::Util::Log.newdestination(:console)
  end

  c.default_facts = {
    :osfamily         => 'Darwin',
    :operatingsystem  => 'Darwin'
  }

  c.before do
    # avoid "Only root can execute commands as other users"
    Puppet.features.stubs(:root? => true)
  end
end

shared_examples :compile, :compile => true do
  it { should compile.with_all_deps }
end
