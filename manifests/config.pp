class rsyslog_to_vendor::config (
  String $loggly_customer_token    = $rsyslog_to_vendor::loggly_customer_token,
  String $new_relic_customer_token = $rsyslog_to_vendor::new_relic_customer_token,
) {
  $base_dir = '/usr/local/rsyslog_to_vendor'
  # create directory for rsyslog_to_vendor support files
  file { $base_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # create directory for TLS certificates
  file { "${base_dir}/certs":
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File[$base_dir],
  }

  # store the Loggly TLS cert inside $cert_path
  file { "${base_dir}/certs/loggly_full.crt":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/loggly_full.crt",
    require => File["${base_dir}/certs"],
  }

  if $loggly_customer_token {
    file { '/etc/rsyslog.d/22-loggly.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/rsyslog/22-loggly.conf.erb"),
      notify  => Exec['restart_rsyslogd'],
      require => [Package['rsyslog-gnutls']]
    }
  }

  if $new_relic_customer_token {
    file { '/etc/rsyslog.d/23-new-relic.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/rsyslog/22-new-relic.conf.erb"),
      notify  => Exec['restart_rsyslogd'],
      require => [Package['rsyslog-gnutls']]
    }
  }
}
