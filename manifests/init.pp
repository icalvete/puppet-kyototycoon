class kyototycoon (

  $hamaster          = false,
  $slave             = false,
  $threads           = $processorcount * 8,
  $db_type           = 'kcd',
  $log_level         = 'le',
  $port              = $kyototycoon::params::port,
  $sid               = $kyototycoon::params::sid,
  $mhost             = undef,
  $mport             = $kyototycoon::params::port,
  $memcached         = false,
  $plex_port         = $kyototycoon::params::plex_port,
  $backup            = true,
  $backup_directory  = $kyototycoon::params::backup_directory,
  $backup_directorys = "${backup_directory}/bin",
  $backup_retention  = 3

) inherits kyototycoon::params {

  if $hamaster or $slave {
    if ! $mhost {
      fail('mhost parameter can\'t be empty with hamaster/slave = true')
    }

    notify {'Remember: ¡¡¡ sid parameter must be unique !!!':}
  }

  anchor {'kyototycoon::begin':
    before => Class['kyototycoon::install']
  }
  class {'kyototycoon::install':
    require => Anchor['kyototycoon::begin']
  }
  class {'kyototycoon::config':
    require => Class['kyototycoon::install'],
    notify  => Class['kyototycoon::service']
  }
  class {'kyototycoon::service':
    require => Class['kyototycoon::config']
  }
  if $backup {
    class {'kyototycoon::backup':
      require => Anchor['kyototycoon::end']
    }
  }
  anchor {'kyototycoon::end':
    require => Class['kyototycoon::service']
  }
}
