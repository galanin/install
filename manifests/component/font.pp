define install::component::font (
  $dirname = $name
) {

  include install::component::font::base

  file {"/usr/share/fonts/truetype/${dirname}":
    ensure  => directory,
    recurse => true,
    source  => "puppet:///modules/install/fonts/${dirname}",
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    notify  => Exec['update_font_cache']
  }

}