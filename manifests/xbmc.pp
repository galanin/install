class install::xbmc {

  apt::ppa {'ppa:team-xbmc/ppa':}

  package {'software-properties-common':}
  package {'python-software-properties':}
  package {'pkg-config':}

  package {'xbmc':
    require => [
      Apt::Ppa['ppa:team-xbmc/ppa'],
      Package['software-properties-common'],
      Package['python-software-properties'],
      Package['pkg-config']
    ]
  }

}
