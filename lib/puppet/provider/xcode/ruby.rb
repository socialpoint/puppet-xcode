Puppet::Type.type(:xcode).provide(:ruby) do
  desc 'Installs the Xcode dmg provided.'

  commands :hdiutil => '/usr/bin/hdiutil'
  commands :curl    => '/usr/bin/curl'
  commands :ditto   => '/usr/bin/ditto'

  attr_reader :version
  attr_reader :manifest

  def self.extract_version(source)
    metadata = /.*(Xcode_([0-9\.?]+){1,})\.dmg/.match source
    version = metadata[2]
    version
  end

  def self.install_dir(resource)
    root = resource[:install_path] ? resource[:install_path] : '/Applications'
    version = extract_version resource[:source]

    bundle = format('Xcode-v%s.app', version)
    path = File.join(root, bundle)

    path
  end

  def self.xcselect(install_path)
    path = format('%s/Contents/Developer', install_path)
    xcodeselect = format('/usr/bin/xcode-select -s %s', path)
    Puppet.debug xcodeselect
    Open3.popen3(xcodeselect.chomp, :chdir => path) do | i, o, e, t|
      e.each { |err| puts err }
      o.each { |out| puts out }
    end
  end

  def self.accepteula(install_path)
    path = format('%s/Contents/Developer/usr/bin', install_path)
    xcodebuild = format('%s/xcodebuild -license accept', path)
    Puppet.debug xcodebuild
    Open3.popen3(xcodebuild.chomp, :chdir => path) do | i, o, e, t|
      e.each { |err| puts err }
      o.each { |out| puts out }
    end
  end

  def self.installapp(source, name, orig_source, version, eula, selected, install_dir = nil)
    appname = format('Xcode-v%s', version)

    if install_dir.nil?
      install_dir = format('/Applications/%s.app', appname)
    end

    ditto '--rsrc', source, install_dir

    Puppet.debug "/var/db/.#{appname.downcase}"
    File.open("/var/db/.#{appname.downcase}", 'w') do |t|
      t.print "name: #{name}\n"
      t.print "source: #{orig_source}\n"
      t.print "install_dir: #{install_dir}\n"
      t.print "eula: #{eula}\n"
      t.print "selected: #{selected}\n"
    end

    if (!eula.casecmp "accept")
      Puppet.debug "Accepting EULA"
      accepteula install_dir
    end

    if (!selected.casecmp "yes")
      Puppet.debug "Selecting Xcode"
      xcselect install_dir
    end
  end

  def self.installpkgdmg(source, name, version, eula, selected, install_path = nil)
    require 'open-uri'

    cached_source = source
    tmpdir = Dir.mktmpdir

    begin
      if %r{\A[A-Za-z][A-Za-z0-9+\-\.]*://} =~ cached_source
        cached_source = File.join(tmpdir, name)
        begin
          curl '-o', cached_source, '-C', '-', '-L', '-s', '--url', source
          Puppet.debug "Success: curl transferred [#{name}]"
        rescue Puppet::ExecutionFailure
          Puppet.debug "curl did not transfer [#{name}].  Falling back to slower open-uri transfer methods."
          cached_source = source
        end
      end

      mount_point = Dir.mktmpdir
      open(cached_source) do |dmg|
        xml_str = hdiutil 'mount', '-nobrowse', '-readonly', '-mountpoint', mount_point, dmg.path

        mounts = [ mount_point ]

        begin
            found_app = false
            mounts.each do |fspath|
            Puppet.debug "trying [#{fspath}]."
              Dir.entries(fspath).select { |f|
                f =~ /Xcode\.app$/i
              }.each do |pkg|
                found_app = true
                installapp("#{fspath}/#{pkg}", name, source, version, eula, selected, install_path)
              end
            end
            Puppet.debug "Unable to find .app in .appdmg. #{name} will not be installed." if !found_app
          ensure
            hdiutil 'eject', mounts[0]
          end
      end

    rescue StandardError => e
      Puppet.debug e.message

    ensure
      FileUtils.remove_entry_secure(tmpdir, true)
      FileUtils.remove_entry_secure(mount_point, true)

    end
  end

  def create
    version = self.class.extract_version @resource[:source]
  end

  def query
    Puppet::FileSystem.exist?(install_manifest) ? {:name => @resource[:name], :ensure => :present} : {:name => @resource[:name], :ensure => :mising}
  end

  def install
    version = self.class.extract_version @resource[:source]

    fail "Xcode PKG DMG's must specify a package source." if @resource[:source].nil?
    fail "Xcode PKG DMG's must specify a package name." if @resource[:name].nil?

    begin
      install_path = self.class.install_dir @resource
      self.class.installpkgdmg(@resource[:source], @resource[:name], version, @resource[:eula], @resource[:selected], install_path)
    rescue StandardError => e
      Puppet.debug e.message
      Puppet.debug e.backtrace

    end
  end

  def uninstall
    version = self.class.extract_version @resource[:source]
    notice("Destroying: #{resource[:name]}@#{version}")
    begin
      if File.exist? install_manifest
        manifest = YAML.load_file install_manifest
        if manifest.key? 'install_dir'
          install_dir = manifest['install_dir']
          FileUtils.rm_rf install_dir if File.exist? install_dir
        end

        FileUtils.rm_rf install_manifest
      end
    rescue StandardError => e
      Puppet.debug e.message
      Puppet.debug e.backtrace

    end
  end

  def exists?
    manifest = install_manifest
    Puppet.debug format('Install Manifest: %s', install_manifest)
    Puppet::FileSystem.exist? manifest
  end

  def install_manifest
    version = self.class.extract_version @resource[:source]
    manifest = format('/var/db/.xcode-v%s', version)
    manifest
  end
end

