class install::mpd {

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

  file {'/var/lib/mpd/music/music6':
    ensure => '/stuff6/music',
    require => Package['mpd'],
  }
  file {'/var/lib/mpd/music/music7':
    ensure => '/stuff7/music',
    require => Package['mpd'],
  }
}
