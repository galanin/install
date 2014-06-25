class install::qutim {

  apt::ppa {'ppa:qutim/qutim':}

  package {'qutim':
    ensure => present,
    require => Apt::Ppa['ppa:qutim/qutim'],
  }

}
