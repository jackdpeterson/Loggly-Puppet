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
# [*new_relic_customer_token*]
#   Customer Token that will be used to identify which New Relic account events
#   will be submitted to.
#   More informaiton on how to generate and obtain the token can be found at New Relic's documentation at:
#      https://docs.newrelic.com/docs/logs/log-api/introduction-log-api/
#
# === Variables
#
# This module uses configuration from the base Loggly class to set
# the certificate path and TLS status.
#
# === Examples
#
#  class { 'rsyslog_to_vendor::rsyslog':
#    loggly_customer_token => '00000000-0000-0000-0000-000000000000',
#  }
#
class rsyslog_to_vendor::rsyslog (
  String $loggly_customer_token    = $rsyslog_to_vendor::loggly_customer_token,
  String $new_relic_customer_token = $rsyslog_to_vendor::new_relic_customer_token,
) inherits rsyslog_to_vendor {
  exec { 'restart_rsyslogd':
    command     => 'service rsyslog restart',
    path        => ['/usr/sbin', '/sbin', '/usr/bin/', '/bin'],
    refreshonly => true,
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

  # TLS configuration requires an extra package to be installed

  package { 'rsyslog-gnutls':
    ensure => 'installed',
    notify => Exec['restart_rsyslogd'],
  }
}
