class install::google_chrome {

  apt::source {'google-chrome-stable':
    location    => 'http://dl.google.com/linux/chrome/deb/',
    release     => 'stable',
    repos       => 'main',
    key         => '7FAC5991',
    key_source  => 'https://dl-ssl.google.com/linux/linux_signing_key.pub',
    include_src => false,
  }

  package {'google-chrome-stable':
    ensure  => present,
    require => Apt::Source['google-chrome-stable'],
  }

}
