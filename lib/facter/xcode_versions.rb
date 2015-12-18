Facter.add(:xcode_versions) do
  confine :kernel => 'Darwin'

  setcode do
    versions = []

    instances = `ls /Applications | grep -i xcode`
      instances.split("\n").each do |i|
      xcodebuild = format('/Applications/%s/Contents/Developer/usr/bin/xcodebuild', i.chomp)
      if File.exists? xcodebuild
        version = `#{xcodebuild} -version`
        parts = version.split("\n")

        buildversion = {
          'version' => parts[0].split(' ')[1],
          'build' => parts[1].split(' ')[2]
        }

        versions << buildversion
      end
    end
    versions
  end
end
