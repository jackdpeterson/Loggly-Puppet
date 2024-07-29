#
# This module sets up the required
# infrastructure for rsyslog to emit logs to vendors (Loggly, New Relic)
#
# Normally this class would not be called directly, but by one of the
# sub-modules that implements specific log sources such as rsyslog_to_vendor::rsyslog.
#
# === Parameters
#
# Defaults for these parameters are inherited from the rsyslog_to_vendor::params class.
#
# [*base_dir*]
#   Base directory to store Loggly support files in.
#
# [*enable_tls*]
#   Enables or disables TLS encryption for shipped log events.
#
# [*cert_path*]
#   Directory to store the Loggly TLS certs in.  Normally this would be
#   relative to $base_dir.
#
# === Authors
#
# Colin Moller <colin@unixarmy.com>
# Jack Peterson <>
#
class rsyslog_to_vendor (
  $base_dir                        = $rsyslog_to_vendor::params::base_dir,
  Boolean $enable_tls              = $rsyslog_to_vendor::params::enable_tls,
  String $loggly_customer_token    = undef,
  String $new_relic_customer_token = undef,
  $cert_path                       = undef,
) inherits rsyslog_to_vendor::params {
  $_cert_path = pick($cert_path, "${base_dir}/certs")

  validate_absolute_path($base_dir)
  validate_absolute_path($_cert_path)
  validate_bool($enable_tls)

  # create directory for rsyslog_to_vendor support files
  file { $base_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  # create directory for TLS certificates
  file { $_cert_path:
    ensure  => 'directory',
    owner   => 'root',
    group   => 'root',
    mode    => '0755',
    require => File[$base_dir],
  }

  # store the Loggly TLS cert inside $cert_path
  file { "${_cert_path}/loggly_full.crt":
    ensure  => 'file',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    source  => "puppet:///modules/${module_name}/loggly_full.crt",
    require => File[$_cert_path],
  }
}

# vim: syntax=puppet ft=puppet ts=2 sw=2 nowrap et
