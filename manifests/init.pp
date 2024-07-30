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
class rsyslog_to_vendor (
  Stdlib::Absolutepath $base_dir   = $rsyslog_to_vendor::params::base_dir,
  String $loggly_customer_token    = undef,
  String $new_relic_customer_token = undef,
) inherits rsyslog_to_vendor::params {
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
}

# vim: syntax=puppet ft=puppet ts=2 sw=2 nowrap et
