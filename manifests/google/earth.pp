class install::google::earth {

  include install::google::key

  apt::source {'google-earth-stable':
    location    => 'http://dl.google.com/linux/earth/deb/',
    release     => 'stable',
    repos       => 'main',
    include_src => false,
    require     => Apt::Key['google-linux-signing-key'],
  }

  package {'lsb-core':}

  package {'google-earth-stable':
    require => [
      Apt::Source['google-earth-stable'],
      Package['lsb-core']
    ],
  }

}
