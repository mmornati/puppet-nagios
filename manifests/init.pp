class nagios::server {

  package { ["nagios","nagios-plugins","nagios-plugins-nrpe"]:
    ensure => installed,
  }

  service { nagios:
    ensure  => running,
    enable  => true,
    require => Exec['change_cfg_rights'],
  }

  # This is because puppet writes the config files using the root user: nagios can't read them
  exec {'change_cfg_rights':
    command => "/bin/find /etc/nagios -type f -name '*cfg' -exec chmod 644 {} \;",
    require => Package['nagios']
  }

  file { 'conf-d':
    path   => '/etc/nagios/conf.d',
    ensure => directory,
    owner  => 'nagios',
    require => Package['nagios'],
  }

  # Collect the nagios_host resources
  Nagios_host <<||>> {
    require => File[conf-d],
    notify  => [Exec['change_cfg_rights'], Service[nagios]],
  }

  Nagios_service <<||>> {
    require => File[conf-d],
    notify  => [Exec['change_cfg_rights'], Service[nagios]],
  }
}
