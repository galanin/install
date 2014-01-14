class install::rsnapshot (
  $snapshots_dir = undef
) {

  if ($install::user == undef) {
    fail('install::user parameter must be set')
  }
  if ($install::group == undef) {
    fail('group parameter must be set')
  }

  package {'rsnapshot':}

  file {"${snapshots_dir}":
    ensure => directory,
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file {'/etc/rsnapshot.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('install/etc/rsnapshot.conf.erb'),
    require => Package['rsnapshot'],
  }
  file {"${snapshots_dir}/etc":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File["${snapshots_dir}"],
  }

  file {'/etc/rsnapshot_work.conf':
    ensure  => present,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('install/etc/rsnapshot_work.conf.erb'),
  }
  file {"${snapshots_dir}/work":
    ensure  => directory,
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File["${snapshots_dir}"],
  }

  file {"/home/${install::user}/.rsnapshot.conf":
    ensure  => present,
    owner   => $install::user,
    group   => $install::group,
    mode    => '0644',
    content => template('install/home/user/.rsnapshot.conf.erb'),
  }
  file {"${snapshots_dir}/${install::user}":
    ensure  => directory,
    owner   => $install::user,
    group   => $install::group,
    mode    => '0755',
    require => File["${snapshots_dir}"],
  }

  cron {'rsnapshot_monthly':
    command => '/usr/bin/rsnapshot monthly',
    user    => 'root',
    minute  => '30',
    hour    => '20',
    monthday => '1',
    target  => 'root',
  }
  cron {'rsnapshot_weekly':
    command => '/usr/bin/rsnapshot weekly',
    user    => 'root',
    minute  => '40',
    hour    => '20',
    weekday => 'Monday',
    target  => 'root',
  }
  cron {'rsnapshot_daily':
    command => '/usr/bin/rsnapshot daily',
    user    => 'root',
    minute  => '50',
    hour    => '20',
    target  => 'root',
  }

  cron {'rsnapshot_work_monthly':
    command  => '/usr/bin/rsnapshot -c /etc/rsnapshot_work.conf monthly',
    user     => 'root',
    minute   => '30',
    hour     => '10',
    monthday => '1',
    target   => 'root',
  }
  cron {'rsnapshot_work_weekly':
    command => '/usr/bin/rsnapshot -c /etc/rsnapshot_work.conf weekly',
    user    => 'root',
    minute  => '0',
    hour    => '11',
    weekday => 'Monday',
    target  => 'root',
  }
  cron {'rsnapshot_work_daily':
    command => '/usr/bin/rsnapshot -c /etc/rsnapshot_work.conf daily',
    user    => 'root',
    minute  => '30',
    hour    => '11',
    target  => 'root',
  }
  cron {'rsnapshot_work_hourly':
    command => '/usr/bin/rsnapshot -c /etc/rsnapshot_work.conf hourly',
    user    => 'root',
    minute  => '0',
    hour    => '*/2',
    target  => 'root',
  }

  cron {"rsnapshot_user_${install::user}_monthly":
    command  => "/usr/bin/rsnapshot -c /home/${install::user}/.rsnapshot.conf monthly",
    user     => $install::user,
    hour     => '19',
    minute   => '30',
    monthday => '1',
    target   => $install::user,
  }
  cron {"rsnapshot_user_${install::user}_weekly":
    command => "/usr/bin/rsnapshot -c /home/${install::user}/.rsnapshot.conf weekly",
    user    => $install::user,
    hour    => '19',
    minute  => '40',
    weekday => 'Monday',
    target  => $install::user,
  }
  cron {"rsnapshot_user_${install::user}_daily":
    command => "/usr/bin/rsnapshot -c /home/${install::user}/.rsnapshot.conf daily",
    user    => $install::user,
    hour    => '19',
    minute  => '50',
    target  => $install::user,
  }

}
