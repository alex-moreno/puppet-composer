# == Type: composer::exec
#
# Either installs from composer.json or updates project or specific packages
#
# === Authors
#
# Thomas Ploch <profiploch@gmail.com>
#
# === Copyright
#
# Copyright 2013 Thomas Ploch
#
define composer::exec (
  $cmd,
  $cwd,
  $packages                 = [],
  $prefer_source            = false,
  $prefer_dist              = false,
  $dry_run                  = false,
  $custom_installers        = false,
  $scripts                  = false,
  $optimize                 = false,
  $interaction              = false,
  $dev                      = false,
  $no_update                = false, 
  $no_progress              = false,
  $update_with_dependencies = false,
  $logoutput                = false,
  $verbose                  = false,
  $refreshonly              = false,
  $user                     = undef,
  $global                   = false,
) {

  require composer

  Exec {
    path        => "/bin:/usr/bin/:/sbin:/usr/sbin:${composer::target_dir}",
    environment => "COMPOSER_HOME=${composer::composer_home}",
    user        => $user,
  }

  if $cmd != 'install' and $cmd != 'update' and $cmd != 'require' {
    fail("Only types 'install', 'update' and 'require'' are allowed, ${cmd} given")
  }

  if $prefer_source and $prefer_dist {
    fail('Only one of \$prefer_source or \$prefer_dist can be true.')
  }

  $command = $global ? {
    true  => "${composer::php_bin} ${composer::target_dir}/${composer::composer_file} global ${cmd}",
    false => "${composer::php_bin} ${composer::target_dir}/${composer::composer_file} ${cmd}",
  }

  exec { "composer_update_${title}":
    command     => template("composer/${cmd}.erb"),
    cwd         => $cwd,
    logoutput   => true,
    refreshonly => $refreshonly,
    user        => $user,
  }
}
