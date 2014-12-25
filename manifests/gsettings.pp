# == Definition: gnome::gsettings
#
# Sets a configuration key in Gnome’s GSettings registry.
#
define install::gsettings(
  $user,
  $schema,
  $key,
  $value,
  $directory = '/usr/share/glib-2.0/schemas',
  $priority  = '25',
) {
  file { "${directory}/${priority}_${user}.gschema.override":
    content => "[${schema}]\n  ${key} = ${value}\n",
  }
  ~>
  exec { "/usr/bin/glib-compile-schemas ${directory}":
    refreshonly => true,
  }
}
