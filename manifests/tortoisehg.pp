class install::tortoisehg {

  apt::ppa {'ppa:tortoisehg-ppa/releases':}

  package {'tortoisehg':
    ensure => present,
    require => Apt::Ppa['ppa:tortoisehg-ppa/releases'],
  }

}
