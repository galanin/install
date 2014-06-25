class install::screencloud {

  apt::source {'screencloud':
    location    => 'http://download.opensuse.org/repositories/home:olav-st/xUbuntu_13.10',
    release     => '/',
    repos       => '',
    key         => 'A2B5E9D5',
    key_source  => 'http://download.opensuse.org/repositories/home:olav-st/xUbuntu_13.10/Release.key',
    include_src => false,
  }

  package {'screencloud':
    ensure  => present,
    require => Apt::Source['screencloud'],
  }

}
