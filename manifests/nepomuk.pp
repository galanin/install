class install::nepomuk (
  $group = undef
) {

  exec {'nepomuk_stop':
    command => 'nepomukctl stop',
    user    => $install::user,
    path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
  }

  file {"/home/${install::user}/.kde/share/config/nepomukbackuprc":
    ensure => present,
    owner  => $install::user,
    group  => $install::group,
    mode   => '0644',
    source => 'puppet:///modules/install/home/user/.kde/share/config/nepomukbackuprc',
  }

  file {"/home/${install::user}/.kde/share/config/nepomukserverrc":
    ensure => present,
    owner  => $install::user,
    group  => $install::group,
    mode   => '0644',
    source => 'puppet:///modules/install/home/user/.kde/share/config/nepomukserverrc',
  }

  file {"/home/${install::user}/.kde/share/config/nepomukstrigirc":
    ensure => present,
    owner  => $install::user,
    group  => $install::group,
    mode   => '0644',
    source => 'puppet:///modules/install/home/user/.kde/share/config/nepomukstrigirc',
  }

}
