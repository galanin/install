class install::plex_media_server (
  $library_dir       = undef,
  $distribution_path = undef
) {

  if ($library_dir == undef) {
    fail('library_dir parameter must be set')
  }
  
  if ($distribution_path != undef) {

    package {'avahi-utils':}
  
    package {'plexmediaserver':
      ensure   => latest,
      provider => 'dpkg',
      source   => $distribution_path,
      require  => Package['avahi-utils'],
    }
  
    exec {'plexmediaserver_stop':
      command => "kill -ABRT $(ps aux | grep 'Plex Media Server' | grep -v grep | awk '{print \$2}')",
      onlyif  => 'ps aux | grep "Plex Media Server" | grep -v grep',
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      require => Package['plexmediaserver'],
    }
  
    user {'plex':
      home    => "${library_dir}",
      require => Exec['plexmediaserver_stop'],
    }
  
    file {"${library_dir}":
      ensure => directory,
      owner  => 'plex',
      group  => 'plex',
      mode   => '0755',
    }
  
    exec {'move_plex_files':
      command => "cp --recursive --force --update /var/lib/plexmediaserver/* ${library_dir}/",
      path    => ['/sbin', '/bin', '/usr/sbin', '/usr/bin'],
      onlyif  => 'test -d /var/lib/plexmediaserver',
      require => [
        Exec['plexmediaserver_stop'],
        File["${library_dir}"]
      ],
    }
  
    file {'/var/lib/plexmediaserver':
      ensure  => absent,
      force   => yes,
      backup  => false,
      require => Exec['move_plex_files'],
    }
  
    service {'plexmediaserver':
      ensure  => running,
      require => [
        User['plex'],
        File['/var/lib/plexmediaserver']
      ]
    }
  }
}