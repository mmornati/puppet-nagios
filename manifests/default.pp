class nagios::default {

  package { ['nagios-plugins-fping', 'nagios-plugins-disk',
  'nagios-plugins-users', 'nagios-plugins-ping', 'nagios-plugins-time',
  'nagios-plugins-load', 'nagios-plugins-ssh', 'nagios-plugins-http',
  'nagios-plugins-procs']:
    ensure => latest
  }

  nagios_hostgroup { 'demo-servers':
    ensure => present,
    alias  => 'Demo Servers HostGroup',
    target => '/etc/nagios/conf.d/hostgroups.cfg',
  }

  @@nagios_host { $::fqdn:
    address       => $::ipaddress,
    check_command => 'check-host-alive!3000.0,80%!5000.0,100%!10',
    hostgroups    => 'demo-servers',
    target        => "/etc/nagios/conf.d/host_${::fqdn}.cfg",
    max_check_attempts => "3",
  }

  @@nagios_service { "check_ping_${hostname}":
    check_command       => "check_ping!100.0,20%!500.0,60%",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_ping",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

   @@nagios_service { "check_root_partition_${hostname}":
    check_command       => "check_local_disk!20%!10%!/",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_root_partition",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }
   
   @@nagios_service { "check_home_partition_${hostname}":
    check_command       => "check_local_disk!20%!10%!/home/",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_home_partition",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }
   
   @@nagios_service { "check_current_users_${hostname}":
    check_command       => "check_local_users!20!50",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_current_users",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

   @@nagios_service { "check_total_processes_${hostname}":
    check_command       => "check_local_procs!20!40!R",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_total_processes",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

   @@nagios_service { "check_current_load_${hostname}":
    check_command       => "check_local_load!5.0,4.0,3.0!10.0,6.0,4.0",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_current_load",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

   @@nagios_service { "check_swap_${hostname}":
    check_command       => "check_local_swap!20!10",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_swap",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

   @@nagios_service { "check_ssh_service_${hostname}":
    check_command       => "check_ssh",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_ssh_service",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

}
