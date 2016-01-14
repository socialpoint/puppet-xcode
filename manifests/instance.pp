# == Define: xcode::instance
#
# Setup the parameters needed for Xcode Installations
#
# === Parameters
#
# [*source_url*]
#   The URL to fetch the DMG from. This can be HTTP, HTTPS, or
#   file system.
#
# [*ensure*]
#
# [*accept*]
#   If set to 'accept', the EULA to Xcode is accepted upon
#   installation, or ignore it.
#
# [*cache_installer*]
#   Keep a local cached copy of the Xcode DMG on the File
#   System.
#
# [*timeout*]
#   The timeout when downloading the Xcode dmg.
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
# xcode::instance {
#   'Xcode 6.1.1':
#     source_url => 'http://intranet.com/squid/xcode/Xcode_6.1.1.dmg';
#
#   'Xcode 7.2':
#     source_url => 'http://intranet.com/squid/xcode/Xcode_7.2.dmg';
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
  $source_url,
  $ensure = present,
  $accept_eula = 'ignore',
  $cache_installer = $::xcode::cache_installers,
  $timeout = $::xcode::timeout
  ) {

  # The base class must be included first because it is used by parameter defaults
  if ! defined(Class['xcode']) {
    fail('You must include the xcode base class before trying to install any instances')
  }

  validate_bool($cache_installer)

  if $ensure == 'absent' {
    $_real_file_ensure = absent
    $_real_package_ensure = absent
  }
  else {
    $_real_file_ensure = file
    $_real_package_ensure = present
  }

  $parts = split($source_url, '/')
  $dmg = $parts[-1]

  if $cache_installer {
    if !defined(File['/opt']) {
      file {
        '/opt':
          ensure => directory;
      }
    }

    if $source_url =~ /^http/ {
      staging::file {
        $dmg:
          source    => $source_url,
          require   => File['/opt'],
          timeout   => $timeout,
          username  => $::xcode::username,
          password  => $::xcode::password;
      }
      $_real_installer = "/opt/staging/xcode/${dmg}"
    }

  }
  else {
    $_real_installer = $source_url

  }

  xcode {
    $dmg:
      ensure      => $ensure,
      source      => $_real_installer,
      accept_eula => $accept_eula;
  }
}
