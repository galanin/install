class install::mongodb {

  apt::source {'mongodb':
    location    => 'http://downloads-distro.mongodb.org/repo/ubuntu-upstart',
    release     => 'dist',
    repos       => '10gen',
    key         => '7F0CEB10',
    key_source  => 'http://keyserver.ubuntu.com/pks/lookup?op=get&fingerprint=on&search=0x7F0CEB10',
    include_src => false,
  }

  package {'mongodb-org':
    ensure =>  present,
    require => Apt::Source['mongodb'],
  }

}
