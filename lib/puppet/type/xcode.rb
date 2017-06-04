# Define the different packaging systems.  Each package system is implemented
# in a module, which then gets used to individually extend each package object.
# This allows packages to exist on the same machine using different packaging
# systems.
Puppet::Type.newtype(:xcode) do
  newparam(:name, :namevar => true) do
    desc 'The package name'

    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, "Name must be a String not #{value.class}"
      end
    end
  end

  newparam(:source) do
    desc 'Where to find the package file'
    validate do |value|
      if !value.is_a?(String)
        raise ArgumentError, "Source must be a String not #{value.class}"
      end
    end
  end

  newparam(:install_path) do
    desc 'Override the default value of /Application/Xcode-v{version}.app'
  end

  newparam(:eula) do
    desc 'What should we do about the EULA for Xcode'
    newvalues(:accept, :ignore, :no)
    defaultto 'ignore'
  end

  newparam(:selected) do
    desc 'Should we xcode-select this version of XCode'
    newvalues(:yes, :no)
    defaultto 'yes'
  end

  newparam(:checksum) do
    desc 'File checksum type'
  end

  newparam(:checksum_type) do
    desc 'File checksum value'
  end

  ensurable do
    desc 'What state the package should be in'
    defaultto :present

    newvalue(:present, :event => :package_installed) do
      provider.install
    end

    newvalue(:absent, :event => :package_removed) do
      provider.uninstall
    end
  end
end
