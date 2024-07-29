# == Class: rsyslog_to_vendor::rsyslog
#
# Configures the rsyslog daemon to submit syslog events to Loggly.
#
# === Parameters
#
# [*loggly_customer_token*]
#   Customer Token that will be used to identify which Loggly account events
#   will be submitted to.
#
#   More information on how to generate and obtain the Customer Token can be
#   found in the Loggly documentation at:
#     http://www.loggly.com/docs/customer-token-authentication-token/
#
# === Variables
#
# This module uses configuration from the base Loggly class to set
# the certificate path and TLS status.
#
# [*cert_dir*]
#   The directory to find the Loggly TLS certs in, as set by the base loggly
#   class.
#
# [*enable_tls*]
#   Enables or disables TLS encryption for shipped events.
#
# === Examples
#
#  class { 'rsyslog_to_vendor::rsyslog':
#    loggly_customer_token => '00000000-0000-0000-0000-000000000000',
#  }
#
# === Authors
#
# Colin Moller <colin@unixarmy.com>
#
class rsyslog_to_vendor::rsyslog (
  String $loggly_customer_token = undef,
  String $new_relic_customer_token = undef,
  Resource $cert_path  = $rsyslog_to_vendor::_cert_path,
  Boolean $enable_tls = $rsyslog_to_vendor::enable_tls,
) inherits loggly {
  validate_string($loggly_customer_token)
  validate_string($new_relic_customer_token)
  validate_absolute_path($cert_path)
  validate_bool($enable_tls)

  if $loggly_customer_token {
    file { '/etc/rsyslog.d/22-loggly.conf':
      ensure  => 'file',
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => template("${module_name}/rsyslog/22-loggly.conf.erb"),
      notify  => Exec['restart_rsyslogd'],
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
    }
  }

  # TLS configuration requires an extra package to be installed
  if $enable_tls == true {
    package { 'rsyslog-gnutls':
      ensure => 'installed',
      notify => Exec['restart_rsyslogd'],
    }

    # Add a dependency on the rsyslog-gnutls package to the configuration
    # snippet so that it will be installed before we generate any config
    Class['loggly'] -> File['/etc/rsyslog.d/22-loggly.conf'] -> Package['rsyslog-gnutls']
  }

  # Call an exec to restart the syslog service instead of using a puppet
  # managed service to avoid external dependencies or conflicts with modules
  # that may already manage the syslog daemon.
  #
  # Note that this will only be called on configuration changes due to the
  # 'refreshonly' parameter.
  exec { 'restart_rsyslogd':
    command     => 'service rsyslog restart',
    path        => ['/usr/sbin', '/sbin', '/usr/bin/', '/bin',],
    refreshonly => true,
  }
}

# vim: syntax=puppet ft=puppet ts=2 sw=2 nowrap et
