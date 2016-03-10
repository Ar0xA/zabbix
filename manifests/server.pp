# == Class: zabbix::server
#
# Install zabbix_server with base configuration and PostgreSQL database
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
class zabbix::server (
  $listenport                 = $zabbix::params::server_listenport,
  $sourceip                   = $zabbix::params::server_sourceip,
  $logfile                    = $zabbix::params::server_logfile,
  $logfilesize                = $zabbix::params::server_logfilesize,
  $debuglevel                 = $zabbix::params::server_debuglevel,
  $pidfile                    = $zabbix::params::server_pidfile,
  $dbhost                     = $zabbix::params::server_dbhost,
  $dbname                     = $zabbix::params::server_dbname,
  $dbschema                   = $zabbix::params::server_dbschema,
  $dbuser                     = $zabbix::params::server_dbuser,
  $dbpassword                 = $zabbix::params::server_dbpassword,
  $dbsocket                   = $zabbix::params::server_dbsocket,
  $dbport                     = $zabbix::params::server_dbport,
  $startpollers               = $zabbix::params::server_startpollers,
  $startipmipollers           = $zabbix::params::server_startipmipollers,
  $startpollersunreachable    = $zabbix::params::server_startpollersunreachable,
  $starttrappers              = $zabbix::params::server_starttrappers,
  $startpingers               = $zabbix::params::server_startpingers,
  $startdiscoverers           = $zabbix::params::server_startdiscoverers,
  $starthttppollers           = $zabbix::params::server_starthttppollers,
  $starttimers                = $zabbix::params::server_starttimers,
  $javagateway                = $zabbix::params::gateway_listenip,
  $javagatewayport            = $zabbix::params::gateway_listenport,
  $startjavapollers           = $zabbix::params::server_startjavapollers,
  $startvmwarecollectors      = $zabbix::params::server_startvmwarecollectors,
  $vmwarefrequency            = $zabbix::params::server_vmwarefrequency,
  $vmwareperffrequency        = $zabbix::params::server_vmwareperffrequency,
  $vmwarecachesize            = $zabbix::params::server_vmwarecachesize,
  $vmwaretimeout              = $zabbix::params::server_vmwaretimeout,
  $snmptrapperfile            = $zabbix::params::server_snmptrapperfile,
  $startsnmptrapper           = $zabbix::params::server_startsnmptrapper,
  $listenip                   = $zabbix::params::server_listenip,
  $housekeepingfrequency      = $zabbix::params::server_housekeepingfrequency,
  $maxhousekeeperdelete       = $zabbix::params::server_maxhousekeeperdelete,
  $senderfrequency            = $zabbix::params::server_senderfrequency,
  $cachesize                  = $zabbix::params::server_cachesize,
  $cacheupdatefrequency       = $zabbix::params::server_cacheupdatefrequency,
  $startdbsyncers             = $zabbix::params::server_startdbsyncers,
  $historycachesize           = $zabbix::params::server_historycachesize,
  $trendcachesize             = $zabbix::params::server_trendcachesize,
  $historytextcachesize       = $zabbix::params::server_historytextcachesize,
  $valuecachesize             = $zabbix::params::server_valuecachesize,
  $timeout                    = $zabbix::params::server_timeout,
  $trappertimeout             = $zabbix::params::server_trappertimeout,
  $unreachableperiod          = $zabbix::params::server_unreachableperiod,
  $unavailabledelay           = $zabbix::params::server_unavailabledelay,
  $unreachabledelay           = $zabbix::params::server_unreachabledelay,
  $alertscriptspath           = $zabbix::params::server_alertscriptspath,
  $externalscripts            = $zabbix::params::server_externalscripts,
  $fpinglocation              = $zabbix::params::server_fpinglocation,
  $fping6location             = $zabbix::params::server_fping6location,
  $sshkeylocation             = $zabbix::params::server_sshkeylocation,
  $logslowqueries             = $zabbix::params::server_logslowqueries,
  $tmpdir                     = $zabbix::params::server_tmpdir,
  $startproxypollers          = $zabbix::params::server_startproxypollers,
  $proxyconfigfrequency       = $zabbix::params::server_proxyconfigfrequency,
  $proxydatafrequency         = $zabbix::params::server_proxydatafrequency,
  $allowroot                  = $zabbix::params::server_allowroot,
  $user                       = $zabbix::params::server_user,
  $include                    = $zabbix::params::server_include,
  $sslcertlocation            = $zabbix::params::server_sslcertlocation,
  $sslkeylocation             = $zabbix::params::server_sslkeylocation,
  $sslcalocation              = $zabbix::params::server_sslcalocation,
  $loadmodulepath             = $zabbix::params::server_loadmodulepath,
  $loadmodule                 = $zabbix::params::server_loadmodule,
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
    '200 Zabbix server' => {
      chain  => $::input_chain_name,
      proto  => 'tcp',
      action => 'accept',
      dport  => $listenport
    }
  }

#  $zabbix_server_additiontal_packages = [ 'net-snmp', 'unixODBC' ]
#  package { $zabbix_server_additiontal_packages:
#    ensure => present
#  }
#  package { 'fping':
#    ensure   => present,
#    require  => Package['zabbix']
#  }
#  package { 'gnutls':
#    ensure => present
#  }
#  package { 'OpenIPMI-libs':
#    ensure => present
#  }
#  package { 'iksemel':
#    ensure   => present,
#    require  => Package['zabbix']
#  }
#  package { 'libssh2':
#    ensure   => present,
#    require  => Package['zabbix']
#  }
  package { 'zabbix-server':
    ensure          => "${version}-1.${os_release}",
#    require         => [ Package['net-snmp'], Package['unixODBC'], Package['fping'], Package['iksemel'], Package['libssh2'] ]
    require => Package['zabbix']
  }
  package { 'zabbix-server-pgsql':
    ensure          => "${version}-1.${os_release}",
    require         => Package['zabbix-server']
  }
  package { 'zabbix-get':
    ensure   => "${version}-1.${os_release}",
    require  => Package['zabbix']
  }
  service { 'zabbix-server':
    ensure    => running,
    enable    => true,
    subscribe => File['zabbix_server.conf'],
#    require   => [ Exec['create_zabbix_data'], Package['OpenIPMI-libs'] ]
    require   => Exec['create_zabbix_data']
  }
  file { 'zabbix_server.conf':
    ensure  => present,
    path    => '/etc/zabbix/zabbix_server.conf',
    owner   => 'zabbix',
    group   => 'zabbix',
    replace => true,
    content => template("zabbix/${version}/zabbix_server.conf.erb"),
    require => Package['zabbix-server']
  }
  class { 'zabbix::templates':
    require => Class['zabbix::web']
  }
  create_resources('firewall', $iptable_entries)
}
