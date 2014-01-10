class install::opera {

  apt::source {'opera':
    location    => 'http://deb.opera.com/opera/',
    release     => 'stable',
    repos       => 'non-free',
    key         => 'A8492E35',
    key_source  => 'http://deb.opera.com/archive.key',
    include_src => false,
  }

  package {'opera':
    ensure => present,
    require => Apt::Source['opera'],
  }

}