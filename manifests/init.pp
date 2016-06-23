# == Class: xcode
#
# Setup the parameters needed for Xcode Installations
#
# === Parameters
#
# [*source_url*]
#   The URL to fetch the DMG from. This can be HTTP, HTTPS, or
#   file system.
#
# [*install_dir*]
#   The directory to install Xcode into, defaults
#   to '/Applications'.
#
# [*username*]
#   Username to authenticate against *source_url* with,
#   if necessary.
#
# [*password*]
#   Password to authenticate against *source_url* with,
#   if necessary.
#
# [*cache_installers*]
#   Keep a local cached copy of the Xcode DMG on the File
#   System.
#
# [*timeout*]
#   The default timeout when downloading the Xcode dmg.
#
# [*instances*]
#   An array of hashes that can be passed into 'xcode::instances'
#
# [*eula*]
#   Automatically accept the EULA
#
# [*selected*]
#   Run 'xcode-select' on the newly installed Xcode
#
# === Variables
#
# Here you should define a list of variables that this module would require.
#
# === Examples
#
# class {
#   '::xcode':
#     source_url => 'http://intranet.com/squid/xcode',
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
class xcode (
  $source_url = $::xcode::params::source_url,
  $install_dir = $::xcode::params::install_dir,
  $username = $::xcode::params::username,
  $password = $::xcode::params::password,
  $cache_installers = $::xcode::params::cache_installers,
  $timeout = $::xcode::params::timeout,
  $eula = $::xcode::params::eula,
  $selected = $::xcode::params::selected,
  $instances = {}
  ) inherits ::xcode::params {

  validate_hash($instances)

  if $instances != {} {
    create_resources('xcode::instance', $instances)
  }
}
