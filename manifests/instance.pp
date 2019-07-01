define kyototycoon::instance (

  $hamaster          = false,
  $slave             = false,
  $service           = 'ktserver',
  $threads           = $processorcount * 8,
  $ulimsiz           = '512m',
  $ulogdir           = 'ulog',
  $ktbin             = 'ktbin',
  $rtsfile           = 'rts',
  $db_type           = 'kcd',
  $log_level         = 'le',
  $port              = undef,
  $sid               = 0,
  $mhost             = undef,
  $mport             = undef,
  $memcached         = false,
  $id                = $name,
  $plex_port         = undef,
  $database_path     = undef,
  $backup            = true,
  $backup_directory  = '/srv/backup/kyototycoon',
  $backup_directorys = "${backup_directory}/bin",
  $backup_retention  = 3,
  $pid_path          = '/var/run',
  $log_path          = "/var/log/${service}",
  $backup_hour       = '5',
  $backup_minute     = '0'

) {

  if $hamaster or $slave {
    if ! $mhost {
      fail('mhost parameter can\'t be empty with hamaster/slave = true')
    }
    if ! $mport {
      fail('mport parameter can\'t be empty with hamaster/slave = true')
    }

    notify {'Remember: ¡¡¡ sid parameter must be unique !!! ':}
  }

  if ! $port {
    fail('port is mandatory.')
  }

  if ! $database_path {
    fail('database_path is mandatory.')
  }

  if $memcached {
    if ! $plex_port {
      fail('with memcached, plex_port is mandatory.')
    }
  }

  if ! $backup_directory {
    fail('backup_directory is mandatory.')
  }


  file {$database_path:
    ensure => directory
  }

  file {"${database_path}/${ktbin}":
    ensure  => directory,
    require => File[$database_path]
  }

  file {"kyototycoon_init_${name}":
    ensure  => present,
    path    => "/etc/init.d/${id}",
    content => template("${module_name}/ktserver_instance.init.erb"),
    mode    => '0775',
  }

  service{ $name:
    ensure    => running,
    enable    => true,
    provider  => 'base',
    hasstatus => false,
    start     => "/etc/init.d/${name} start",
    stop      => "/etc/init.d/${name} stop",
    pattern   => "/var/run/ktserver${name}",
  }

  file { "${backup_directorys}/dbbackup_tool_${name}":
    ensure  => present,
    content => template('kyototycoon/dbbackup_tool_instance.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }

  file { "${database_path}/ktbin/dbbackup":
    ensure  => present,
    content => template('kyototycoon/dbbackup_script_instance.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0744',
  }

  cron { "kyototycoon_backup_${name}":
    command => "${backup_directorys}/dbbackup_tool_${name}",
    user    => 'root',
    hour    => $backup_hour,
    minute  => $backup_minute,
  }
}
