class install::postgresql {

  apt::source {'postgresql':
    location    => 'http://apt.postgresql.org/pub/repos/apt/',
    release     => 'trusty-pgdg',
    repos       => 'main',
    key         => 'ACCC4CF8',
    key_source  => 'https://www.postgresql.org/media/keys/ACCC4CF8.asc',
    include_src => false,
  }

  package {'postgresql-client-9.4':
    ensure =>  present,
    require => Apt::Source['postgresql'],
  }

  package {'postgresql-9.4':
    ensure =>  present,
    require => Apt::Source['postgresql'],
  }

  package {'postgresql-contrib-9.4':
    ensure =>  present,
    require => Apt::Source['postgresql'],
  }

  package {'postgresql-server-dev-9.4':
    ensure =>  present,
    require => Apt::Source['postgresql'],
  }

  package {'postgresql-common':}

}