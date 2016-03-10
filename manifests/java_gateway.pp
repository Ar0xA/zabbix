# == Class: zabbix::java_gateway
#
# Install zabbix-java-gateway on a server (can be stand-alone server or Zabbix server)
#
# === Parameters
#
# version = Zabbix version. Defaults to 2.4.5
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::java_gateway (
  $listenip                   = $zabbix::params::gateway_listenip,
  $listenport                 = $zabbix::params::gateway_listenport,
  $pidfile                    = $zabbix::params::gateway_pidfile,
  $startpollers               = $zabbix::params::gateway_startpollers,
  $timeout                    = $zabbix::params::gateway_timeout,
  $version                    = $zabbix::params::version
) {
  case $::operatingsystemrelease {
    /^5.*/: {
      $os_release = 'el5'
    }
    /^6.*/: {
      $os_release = 'el6'
    }
    /^7.*/: {
      $os_release = 'el7'
    }
    default: {
      fail 'Unsupported OS'
    }
  }
  $iptable_entries = {
    '200 Zabbix java-gateway' => {
      chain  => $::input_chain_name,
      proto  => 'tcp',
      action => 'accept',
      dport  => $listenport
    }
  }

  package { 'java-1.6.0-openjdk':
    ensure => present
  }
  package { 'zabbix-java-gateway':
    ensure   => "${version}-1.${os_release}",
    require  => [ Package['java-1.6.0-openjdk'], Package['zabbix'] ]
  }
  service { 'zabbix-java-gateway':
    ensure    => running,
    enable    => true,
    subscribe => File['zabbix_java_gateway.conf']
  }
  file { 'zabbix_java_gateway.conf':
    ensure  => present,
    path    => '/etc/zabbix/zabbix_java_gateway.conf',
    owner   => 'zabbix',
    group   => 'zabbix',
    replace => true,
    content => template("zabbix/${version}/zabbix_java_gateway.conf.erb"),
    require => Package['zabbix-java-gateway']
  }
  create_resources('firewall', $iptable_entries)
}
