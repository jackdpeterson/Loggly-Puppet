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
  Optional[String]                    $loggly_customer_token = undef,
  Optional[String]                    $new_relic_customer_token = undef,
  Boolean                             $service_enable,
  Enum['running', 'stopped']          $service_ensure,
  Boolean                             $service_manage,
  String                              $service_name,
  Optional[String]                    $service_provider,
  Boolean                             $service_hasstatus,
  Boolean                             $service_hasrestart,
) {
  contain rsyslog_to_vendor::install
  contain rsyslog_to_vendor::config
  contain rsyslog_to_vendor::service

  Class[rsyslog_to_vendor::install]
  -> Class[rsyslog_to_vendor::config]
  -> Class[rsyslog_to_vendor::service]
}