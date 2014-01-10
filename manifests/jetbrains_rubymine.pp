class install::jetbrains_rubymine (
  $distribution_path = undef,
  $distribution_name = undef,
  $deployment_root   = '/opt',
  $deployment_group  = 'rubymine',
  $tmp_dir           = '/tmp') {

  if ($distribution_path == undef) {
    fail('distribution_path parameter must be set')
  }
  if ($distribution_name == undef) {
    fail('distribution_name parameter must be set')
  }
  if !('.tar.gz' in $distribution_path) {
    fail('distribution must be .tar.gz')
  }

  # Resource default for Exec
  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  $rubymine_tmp_dir = "${tmp_dir}/install-jetbrains-rubymine"

  file {$rubymine_tmp_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  group {$deployment_group:
    ensure => present,
  }

  exec {"unpack_jetbrains_${distribution_name}":
    command => "tar -C ${rubymine_tmp_dir} --no-same-owner -zxf ${distribution_path}",
    group   => $deployment_group,
    umask   => '0002',
    require => [
      File[$rubymine_tmp_dir],
      Group[$deployment_group]
    ],
  }

  file {$deployment_root:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  $deployment_dir = "${deployment_root}/${distribution_name}"
  file {$deployment_dir:
    ensure  => directory,
    owner   => 'root',
    group   => $deployment_group,
    mode    => '0775',
    require => [
      File[$deployment_root],
      Group[$deployment_group]
    ],
  }

  exec {"move_jetbrains_${distribution_name}":
    command => "mv -f ${rubymine_tmp_dir}/*/* ${deployment_dir}",
    creates => "${deployment_dir}/bin/rubymine.sh",
    require => [
      Exec["unpack_jetbrains_${distribution_name}"],
      File[$deployment_dir]
    ],
  }

}
