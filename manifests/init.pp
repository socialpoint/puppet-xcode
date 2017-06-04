# == Class: xcode
#
# Setup the parameters needed for Xcode Installations
#
# === Parameters
#
# [*source*]
#   The URL to fetch the DMG from. This can be HTTP, HTTPS, or
#   file system.
#
# [*install_dir*]
#   The directory to install Xcode into, defaults
#   to '/Applications'.
#
# [*auth_username*]
#   Username to authenticate against *source* with,
#   if necessary.
#
# [*auth_password*]
#   Password to authenticate against *source* with,
#   if necessary.
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
#     source => 'http://intranet.com/squid/xcode',
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
  $source = $::xcode::params::source,
  $install_dir = $::xcode::params::install_dir,
  $username = $::xcode::params::username,
  $password = $::xcode::params::password,
  $timeout = $::xcode::params::timeout,
  $eula = $::xcode::params::eula,
  $selected = $::xcode::params::selected,
  $instances = {}
  ) inherits ::xcode::params {

  #validate_hash($instances)
  validate_legacy(Hash, 'validate_hash', $instances)

  if $instances != {} {
    create_resources('xcode::instance', $instances)
  }
}
