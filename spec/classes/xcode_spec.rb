require 'spec_helper'

describe 'xcode' do
  it { should create_class('xcode') }
  it { should contain_class('xcode::params') }
end
