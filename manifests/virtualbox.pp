class install::virtualbox (
  $virtualbox_vms_dir = undef,
  $extpack_path    = undef,
  $version         = undef
) {

  if ($install::ubuntu == undef) {
    fail('install::ubuntu parameter must be set')
  }
  apt::source {'virtualbox':
    location    => 'http://download.virtualbox.org/virtualbox/debian',
    release     => $install::ubuntu,
    repos       => 'contrib',
    key         => '98AB5139',
    key_source  => 'http://download.virtualbox.org/virtualbox/debian/oracle_vbox.asc',
    include_src => false,
  }

  if ($version == undef) {
    fail('version parameter must be set')
  }
  package {"virtualbox-${version}":
    ensure => present,
    require => Apt::Source['virtualbox'],
  }

  if ($install::user == undef) {
    fail('install::user parameter must be set')
  }
  if ($install::group == undef) {
    fail('install::group parameter must be set')
  }
  file {$virtualbox_vms_dir:
    ensure => directory,
    owner  => $install::user,
    group  => $install::group,
    mode   => '0755',
  }

  exec {'virtualbox-set-machinefolder':
    command => "VBoxManage setproperty machinefolder ${virtualbox_vms_dir}",
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    user    => $install::user,
    group   => $install::group,
    require => [
      File["${virtualbox_vms_dir}"],
      Package["virtualbox-${version}"]
    ]
  }

  if ($extpack_path != undef) {
    exec {'virtualbox-install-extpack':
      command => "VBoxManage extpack install --replace ${extpack_path}",
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      require => Package["virtualbox-${version}"],
    }
  }

  exec {'virtualbox-register-vms':
    command => "find ${virtualbox_vms_dir} -name '*.vbox' -or -name '*.xml' -print0 |xargs -0 -L 1 VBoxManage registervm",
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
    returns => [0, 123],
    user    => $install::user,
    group   => $install::group,
    require => [
      File["${virtualbox_vms_dir}"],
      Package["virtualbox-${version}"],
      Exec['virtualbox-set-machinefolder']
    ]
  }
}
