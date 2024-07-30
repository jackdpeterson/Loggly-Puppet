define rsyslog_to_vendor::rsyslog::logfile (
  String $logname,
  Stdlib::Absolutepath $filepath                                                          = $title,
  Enum['emerg', 'alert', 'crit', 'error', 'warning', 'notice', 'info', 'debug'] $severity = 'info'
) {
  $_t = split($filepath, '/')
  $_logname = pick($logname, $_t[-1])

  # This template uses $logname and $filepath
  file { "/etc/rsyslog.d/${_logname}.conf":
    content => template("${module_name}/log.conf.erb"),
    notify  => Exec['restart_rsyslogd'],
  }
}
