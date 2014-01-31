class nagios::webserver {

  @@nagios_service { "check_http_service_${hostname}":
    check_command       => "check_http",
    use                 => "generic-service",
    host_name           => "$fqdn",
    notification_period => "24x7",
    service_description => "${hostname}_check_http_service",
    target              => "/etc/nagios/conf.d/host_services_${::fqdn}.cfg"
  }

}
