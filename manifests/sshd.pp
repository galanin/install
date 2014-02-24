class install::sshd {
  if ($install::user == undef) {
    fail('install::user parameter must be set')
  }

  package {'openssh-server':}

  service { 'ssh':
    ensure  => 'running',
    enable  => 'true',
    require => Package['openssh-server'],
  }
  
  file {'/etc/ssh/sshd_config':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
    content => template('install/etc/ssh/sshd_config.erb'),
    require => Package['openssh-server'],
    notify  => Service['ssh'],
  }

}
