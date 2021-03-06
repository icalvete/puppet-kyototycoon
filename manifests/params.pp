class kyototycoon::params {

  $service       = 'ktserver'
  $package       = 'kyototycoon'
  $database_path = '/var/lib/ktserver'
  $pid_path      = '/var/run'
  $log_path      = "/var/log/${service}"

  $port          = '1979'
  $ulimsiz       = '512m'
  $ulogdir       = 'ulog'
  $ktbin         = 'ktbin'
  $sid           = '0'
  $rtsfile       = 'rts'
  $plex_port     = '11211'

  $backup_dir = lookup(
    'backup_dir',
    String,
    'first',
    '/srv/backup'
  )

  $backup_directory = "${$backup_dir}/kyototycoon"

  case $::operatingsystem {
    /^(Debian|Ubuntu)$/: {
    }
    /^(Redhat|CentOS)$/: {
      fail ("${::operatingsystem} not supported.")
    }
    default: {
      fail ("${::operatingsystem} not supported.")
    }
  }
}

