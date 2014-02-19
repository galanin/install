class install::google::key {
  apt::key {'google-linux-signing-key':
    key         => '7FAC5991',
    key_source  => 'https://dl-ssl.google.com/linux/linux_signing_key.pub',
  }
}
