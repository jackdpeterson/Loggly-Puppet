class rsyslog_to_vendor::install {
  package { 'rsyslogd':
    ensure => installed
  }

  package { 'rsyslog-gnutls':
    ensure  => 'installed',
    require => Package['rsyslog'],
    notify  => Exec['restart_rsyslogd'],
  }
}
