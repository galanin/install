class install::transmission {
  if ($install::user == undef) {
    fail('install::user parameter must be set')
  }

  package {'transmission-daemon':}

  service { 'transmission-daemon':
    ensure  => 'running',
    enable  => 'true',
    require => Package['transmission-daemon'],
  }

  file {'/etc/default/transmission-daemon':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('install/etc/default/transmission-daemon.erb'),
    require => Package['transmission-daemon'],
    notify  => Service['transmission-daemon'],
  }

  file {'/etc/init/transmission-daemon.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('install/etc/init/transmission-daemon.conf.erb'),
    require => Package['transmission-daemon'],
    notify  => Service['transmission-daemon'],
  }
}
