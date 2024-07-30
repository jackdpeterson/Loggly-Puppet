# == Define: rsyslog_to_vendor::rsyslog::logfile
#
# Adds the monitoring of a file.
#
# === Parameters
#
# [*logname*]
#   The label to be applied to this log file.
#   If it is not present it will default to the short name of the file
#
# [*filepath*]
#   The fully qualified path to the file to monitor.
#
# [*severity*]
#   Standard syslog severity levels.  Default: info
#
# === Variables
#
#
# [*_t*]
#   An internal temp variable used for string parsing
#
# === Examples
#
#  rsyslog_to_vendor::rsyslog::logfile { '/opt/customapp/log':
#    logname => 'MY_App',
#  }
#
# === Authors
#
# Colin Moller <colin@unixarmy.com>
#
define rsyslog_to_vendor::rsyslog::logfile (
  String $logname    = undef,
  String $filepath = $title,
  Enum['emerg', 'alert', 'crit', 'error', 'warning', 'notice', 'info', 'debug'] $severity = 'info'
) {
  validate_absolute_path($filepath)

  $_t = split($filepath, '/')
  $_logname = pick($logname, $_t[-1])

  validate_string($_logname)

  # This template uses $logname and $filepath
  file { "/etc/rsyslog.d/${_logname}.conf":
    content => template("${module_name}/log.conf.erb"),
    notify  => Exec['restart_rsyslogd'],
  }
}

# vi:syntax=puppet:filetype=puppet:ts=4:et:
