Puppet::Functions.create_function(:'osx_version') do
  confine :kernel => 'Darwin'

  setcode { Gem::Version.new(scope['facts']['os']['macosx']['version']['major']) }

end
