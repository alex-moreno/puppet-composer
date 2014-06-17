# == Class: composer::params
#
# The parameters for the composer class and corresponding definitions
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
# Andrew Johnstone <andrew@ajohnstone.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
class composer::params {
  $composer_home = $::composer_home
  $proxyuri = hiera('proxy_config::proxyuri', 'http://94.126.104.207:8080')  

  # Support Amazon Linux which is supported by RedHat family
  if $::osfamily == 'Linux' and $::operatingsystem == 'Amazon' {
    $family = 'RedHat'
  } else {
    $family = $::osfamily
  }

  case $family {
    'Debian': {
      $target_dir      = '/usr/local/bin'
      $composer_file   = 'composer'
      $download_method = 'curl'
      $method_package  = $download_method
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = ''
      $php_bin         = 'php'
      $suhosin_enabled = false
    }
    'RedHat', 'Centos': {
      $target_dir      = '/usr/local/bin'
      $composer_file   = 'composer'
      $download_method = 'curl'
      $method_package  = $download_method
      $logoutput       = false
      $tmp_path        = '/tmp'
      $php_package     = ''
      $php_bin         = 'php'
      $suhosin_enabled = false
    }
    default: {
      fail("Unsupported platform: ${family}")
    }
  }
}
