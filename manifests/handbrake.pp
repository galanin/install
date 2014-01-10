class install::handbrake {

  apt::ppa {'ppa:stebbins/handbrake-snapshots':}

  package {'handbrake-gtk':
    ensure => present,
    require => Apt::Ppa['ppa:stebbins/handbrake-snapshots'],
  }

}