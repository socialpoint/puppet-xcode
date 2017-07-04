# == Define: xcode::instance
#
# Setup the parameters needed for Xcode Installations
#
# === Parameters
#
# [*source*]
#   The URL to fetch the DMG from. This can be HTTP, HTTPS, or
#   file system.
#
# [*ensure*]
#
# [*accept*]
#   If set to 'accept', the EULA to Xcode is accepted upon
#   installation, or ignore it.
#
# [*timeout*]
#   The timeout when downloading the Xcode dmg.
#
# [*auth_username*]
#   Username to authenticate against *source* with,
#   if necessary.
#
# [*auth_password*]
#   Password to authenticate against *source* with,
#   if necessary.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
# xcode::instance {
#   'Xcode 6.1.1':
#     source => 'http://intranet.com/squid/xcode/Xcode_6.1.1.dmg',
#
#   'Xcode 7.2':
#     source => 'http://intranet.com/squid/xcode/Xcode_7.2.dmg',
# }
#
# === Authors
#
# Mike Delaney <github@mldelaney.com>
#
# === Copyright
#
# Copyright 2015 Mike Delaney, unless otherwise noted.
#
define xcode::instance(
  $source,
  $ensure        = present,
  $eula          = 'ignore',
  $selected      = 'no',
  $username      = $::xcode::username,
  $password      = $::xcode::password,
  $checksum      = undef,
  $checksum_type = undef,
) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['xcode']) {
    fail('You must include the xcode base class before trying to install any instances')
  }

  validate_legacy(String, 'validate_string', $source)
  validate_legacy(String, 'validate_string', $selected)

  if $ensure == 'absent' {
    $_real_file_ensure = absent
    $_real_package_ensure = absent
  }
  else {
    $_real_file_ensure = file
    $_real_package_ensure = present
  }

  $parts = split($source, '/')
  $dmg = $parts[-1]

  xcode {
    $dmg:
      ensure        => $ensure,
      eula          => $eula,
      selected      => $selected,
      checksum      => $checksum,
      checksum_type => $checksum_type;
  }

    if !defined(File['/opt']) {
      file {
        '/opt':
          ensure => directory;
      }
    }

  if $source =~ /^http/ {
    archive {
      $dmg:
        ensure        => $ensure,
        path          => "/opt/${dmg}",
        source        => $source,
        username      => $username,
        password      => $password,
        provider      => ruby,
        checksum      => $checksum,
        checksum_type => $checksum_type,
        require       => File['/opt'];
    }

    Xcode[$dmg] {
      require => Archive[$dmg]
    }

    $_real_installer = "/opt/${dmg}"
  }
  else {
    $_real_installer = $source
  }

  Xcode[$dmg] {
    source => $_real_installer
  }
}
