class install::sshd {
  if ($install::user == undef) {
    fail('install::user parameter must be set')
  }

  package {'transmission-daemon':}

  service { 'transmission-daemon':
    ensure  => 'running',
    enable  => 'true',
    require => Package['transmission-daemon'],
  }

}
