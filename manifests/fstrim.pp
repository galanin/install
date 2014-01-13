class install::fstrim {

  cron {'fstrim':
    command => '/bin/date >> /var/log/fstrim.log && /sbin/fstrim --verbose / >> /var/log/fstrim.log',
    user => 'root',
    minute => '0',
    hour  => '12',
    target  => 'root',
  }

}