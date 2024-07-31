class rsyslog_to_vendor::install {
  package { 'rsyslogd':
    ensure => installed
  }

  package { 'rsyslog-gnutls':
    ensure  => 'installed',
    require => Package['rsyslogd'],
    notify  => Exec['restart_rsyslogd'],
  }
}
