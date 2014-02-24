class install::sshd {

  package {'mpd':}

  service { 'mpd':
    ensure  => 'running',
    enable  => 'true',
    require => Package['mpd'],
  }

  file {'/etc/mpd.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('install/etc/mpd.conf.erb'),
    require => Package['mpd'],
    notify  => Service['mpd'],
  }

}
