class install::component::font::base {

  exec {'update_font_cache':
    command     => shellquote('/usr/bin/env', 'fc-cache', '-f'),
    refreshonly => true
  }

}