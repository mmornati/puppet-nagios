class nagios::server {

  package { ["nagios","nagios-plugins","nagios-plugins-nrpe", "perl-Net-SNMP"]:
    ensure => installed,
  }

  service { nagios:
    ensure  => running,
    enable  => true,
    require => Exec['change_cfg_rights'],
  }

  file {'commands.cfg':
    ensure  => present,
    path    => '/etc/nagios/conf.d/commands.cfg',
    owner   => 'nagios',
    group   => 'nagios',
    source  => 'puppet:///modules/nagios/commands.cfg',
    require => [ Package['nagios'], File['conf-d'] ]
  }

  file {'hostgroups.cfg':
    ensure  => present,
    path    => '/etc/nagios/conf.d/hostgroups.cfg',
    owner   => 'nagios',
    group   => 'nagios',
    source  => 'puppet:///modules/nagios/hostgroups.cfg',
    require => [ Package['nagios'], File['conf-d'] ]
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

  # Collect all nagios resources
  Nagios_host <<||>> {
    require => File[conf-d],
    notify  => [Exec['change_cfg_rights'], Service[nagios]],
  }

  Nagios_service <<||>> {
    require => File[conf-d],
    notify  => [Exec['change_cfg_rights'], Service[nagios]],
  }
  
  Nagios_servicegroup <<||>> {
    require => File[conf-d],
    notify  => [Exec['change_cfg_rights'], Service[nagios]],
  }

  Nagios_hostgroup <<||>> {
    require => File[conf-d],
    notify  => [Exec['change_cfg_rights'], Service[nagios]],
  }

}
