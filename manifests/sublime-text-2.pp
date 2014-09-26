class install::sublime-text-2 {

  apt::ppa {'ppa:webupd8team/sublime-text-2':}

  package {'sublime-text':
    ensure => present,
    require => Apt::Ppa['ppa:webupd8team/sublime-text-2'],
  }

}
