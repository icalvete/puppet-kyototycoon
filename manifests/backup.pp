class kyototycoon::backup {

  file { $kyototycoon::backup_directory:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
  }

  file { $kyototycoon::backup_directorys:
    ensure  => 'directory',
    mode    => '0755',
    owner   => 'root',
    group   => 'root',
    recurse => true,
    require => File[$kyototycoon::backup_directory]
  }

  file { "${kyototycoon::backup_directorys}/dbbackup_tool":
    ensure  => present,
    content => template('kyototycoon/dbbackup_tool.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => File[$kyototycoon::backup_directorys],
  }

  file { "${kyototycoon::params::database_path}/ktbin/dbbackup":
    ensure  => present,
    content => template('kyototycoon/dbbackup_script.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
    require => File[$kyototycoon::backup_directorys],
  }

  cron { 'kyototycoon_backup':
    command => "${kyototycoon::backup_directorys}/dbbackup_tool",
    user    => 'root',
    hour    => '2',
    minute  => '0',
    require => File["${kyototycoon::backup_directorys}/dbbackup_tool"]
  }
}
