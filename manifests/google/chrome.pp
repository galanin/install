class install::google::chrome {

  include install::google::key

  apt::source {'google-chrome-stable':
    location    => 'http://dl.google.com/linux/chrome/deb/',
    release     => 'stable',
    repos       => 'main',
    include_src => false,
    require     => Apt::Key['google-linux-signing-key'],
  }

  package {'google-chrome-stable':
    ensure  => present,
    require => Apt::Source['google-chrome-stable'],
  }

}
