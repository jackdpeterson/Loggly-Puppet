class rsyslog_to_vendor::service {
  if $rsyslog_to_vendor::service_manage == true {
    service { 'rsyslog':
      ensure     => $rsyslog_to_vendor::service_ensure,
      enable     => $rsyslog_to_vendor::service_enable,
      name       => $rsyslog_to_vendor::service_name,
      provider   => $rsyslog_to_vendor::service_provider,
      hasstatus  => $rsyslog_to_vendor::service_hasstatus,
      hasrestart => $rsyslog_to_vendor::service_hasrestart,
    }
  }

  exec { 'restart_rsyslogd':
    command     => 'service rsyslog restart',
    path        => ['/usr/sbin', '/sbin', '/usr/bin/', '/bin'],
    refreshonly => true,
  }
}
