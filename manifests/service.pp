class kyototycoon::service {

  service{ 'ktserver':
    ensure    => running,
    provider  => 'base',
    hasstatus => false,
    start     => "/etc/init.d/ktserver start",
    stop      => "/etc/init.d/ktserver stop",
    pattern   => "/usr/bin/ktserver",
  }
}

