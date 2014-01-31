class nagios::default {
  @@nagios_host { $::fqdn:
    address       => $::ipaddress,
    check_command => 'check-host-alive!3000.0,80%!5000.0,100%!10',
    hostgroups    => 'linux-servers',
    target        => "/etc/nagios/conf.d/host_${::fqdn}.cfg",
    max_check_attempts => "3",
  }

  @@nagios_service { "check_ping_${hostname}":
    check_command => "check_ping!100.0,20%!500.0,60%",
    use => "generic-service",
    host_name => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_ping"
   }
}
