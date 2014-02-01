class nagios::default {

  package { ['nagios-plugins-fping', 'nagios-plugins-ping']:
    ensure => installed
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

   @@nagios_service { "check_disks_${hostname}":
    check_command       => "check_snmp_disk!public!20%!10%",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_disks",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }
 
   @@nagios_service { "check_load_${hostname}":
    check_command       => "check_snmp_load!public!85%!90%!/",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_load",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }

   @@nagios_service { "check_memory_${hostname}":
    check_command       => "check_snmp_mem!public!85,50!95,60",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_memory",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
   }
   
}
