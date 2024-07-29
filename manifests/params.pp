# == Class: rsyslog_to_vendor::params
#
# Provides defaults for the rsyslog_to_vendor base class.
#
# Normally this class would not be called on its own, but by the rsyslog_to_vendor class.
#
class rsyslog_to_vendor::params {
  case $facts['os']['name'] {
    'RedHat', 'Ubuntu', 'Fedora', 'CentOS', 'Debian': {
      # base directory for rsyslog_to_vendor support files
      $base_dir = '/usr/local/rsyslog_to_vendor'

      # TLS support is enabled by default to prevent sniffing of logs
      $enable_tls = true
    }

    default: {
      fail("${facts['os']['name']} not supported")
    }
  }
}
