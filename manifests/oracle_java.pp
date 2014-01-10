class install::oracle_java (
  $distribution_path = undef,
  $distribution_name = undef,
  $deployment_root   = '/usr/local/jvm',
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

  Exec {
    path => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  $java_tmp_dir = "${tmp_dir}/install-oracle-java"

  file {$java_tmp_dir:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0700',
  }

  exec {"unpack_oracle_${distribution_name}":
    command => "tar -C ${java_tmp_dir} --no-same-owner -zxf ${distribution_path}",
    require => File[$java_tmp_dir],
  }

  file {$deployment_root:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  $deployment_dir = "${deployment_root}/${distribution_name}"
  file {$deployment_dir:
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File[$deployment_root],
  }

  exec {"move_oracle_${distribution_name}":
    command => "mv -f ${java_tmp_dir}/*/* ${deployment_dir}",
    creates => "${deployment_dir}/bin/java",
    require => [
      Exec["unpack_oracle_${distribution_name}"],
      File[$deployment_dir]
    ],
  }

  file {'/etc/profile.d/oracle_java.sh':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    content => template('install/etc/profile.d/oracle_java.sh.erb'),
    require => Exec["move_oracle_${distribution_name}"],
  }

  exec {'exec/etc/profile.d/oracle_java.sh':
    command => '/etc/profile.d/oracle_java.sh',
    require => File['/etc/profile.d/oracle_java.sh']
  }

}
