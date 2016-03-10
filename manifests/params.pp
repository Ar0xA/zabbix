# == Class: zabbix::params
#
# This class makes parameters used by zabbix_agent to build several templates needed by the zabbix_agent class
#
# === Parameters
#
# zabbix_server = IP number of zabbix server
# zabbix_agent_listenip = IP adress to listen to. Default to $::ipaddress
# zabbix_agent_listenport = Port zabbix agent listens on. Default to 10050.
# Other parameters are considered default but can be changed in the params file
#
# === Variables
#
# All class variables are set in helper class
# zabbix::params and are presented as class parameters in
# this class. So, one must not use class variables.
#
# === Examples
#
#  include zabbix::params
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#

class zabbix::params (
  #Zabbix-db
  $dbtype                         = 'postgresql',
  $dbversion                      = '9.4',
  $datadir                        = '/database',
  $instancename                   = 'mios',
  #zabbix-server
  $server_ip                      = '192.168.5.125',
  $server_listenport              = '10051',
  $server_sourceip                = undef,
  $server_logfile                 = '/var/log/zabbix/zabbix_server.log',
  $server_logfilesize             = '0',
  $server_debuglevel              = '3',
  $server_pidfile                 = '/var/run/zabbix/zabbix_server.pid',
  $server_dbhost                  = 'localhost',
  $server_dbname                  = 'zabbix',
  $server_dbschema                = undef,
  $server_dbuser                  = 'zabbix',
  $server_dbpassword              = 'zabbix',
  $server_dbsocket                = '/var/lib/mysql/mysql.sock',
  $server_dbport                  = '5432',
  #zabbix-server-advanced
  $server_startpollers            = '25',
  $server_startipmipollers        = '0',
  $server_startpollersunreachable = '5',
  $server_starttrappers           = '5',
  $server_startpingers            = '1',
  $server_startdiscoverers        = '15',
  $server_starthttppollers        = '1',
  $server_starttimers             = '1',
  $server_startjavapollers        = '5',
  $server_startvmwarecollectors   = '0',
  $server_vmwarefrequency         = '60',
  $server_vmwareperffrequency     = '60',
  $server_vmwarecachesize         = '8M',
  $server_vmwaretimeout           = '10',
  $server_snmptrapperfile         = '/var/log/snmptt/snmptt.log',
  $server_startsnmptrapper        = '1',
  $server_listenip                = '0.0.0.0',
  $server_housekeepingfrequency   = '1',
  $server_maxhousekeeperdelete    = '500',
  $server_senderfrequency         = '30',
  $server_cachesize               = '8M',
  $server_cacheupdatefrequency    = '60',
  $server_startdbsyncers          = '4',
  $server_historycachesize        = '8M',
  $server_trendcachesize          = '4M',
  $server_historytextcachesize    = '16M',
  $server_valuecachesize          = '8M',
  $server_timeout                 = '30',
  $server_trappertimeout          = '300',
  $server_unreachableperiod       = '45',
  $server_unavailabledelay        = '60',
  $server_unreachabledelay        = '15',
  $server_alertscriptspath        = '/usr/lib/zabbix/alertscripts',
  $server_externalscripts         = '/usr/lib/zabbix/externalscripts',
  $server_fpinglocation           = '/usr/sbin/fping',
  $server_fping6location          = '/usr/sbin/fping6',
  $server_sshkeylocation          = undef,
  $server_logslowqueries          = '0',
  $server_tmpdir                  = '/tmp',
  $server_startproxypollers       = '1',
  $server_proxyconfigfrequency    = '3600',
  $server_proxydatafrequency      = '1',
  $server_allowroot               = '0',
  $server_user                    = 'zabbix',
  $server_include                 = undef,
  $server_sslcertlocation         = '${datadir}/zabbix/ssl/certs', #lint:ignore:single_quote_string_with_variables
  $server_sslkeylocation          = '${datadir}/zabbix/ssl/keys', #lint:ignore:single_quote_string_with_variables
  $server_sslcalocation           = undef,
  $server_loadmodulepath          = '${libdir}/modules', #lint:ignore:single_quote_string_with_variables
  $server_loadmodule              = undef,
  #zabbix-java-gateway
  $gateway_listenip               = 'localhost',
  $gateway_listenport             = '10052',
  $gateway_pidfile                = '/var/run/zabbix/zabbix_java.pid',
  $gateway_startpollers           = '5',
  $gateway_timeout                = '15',
  #zabbix-agent
  $agent_pidfile                  = '/var/run/zabbix/zabbix_agentd.pid',
  $agent_logfilesize              = '0',
  $agent_debuglevel               = '3',
  $agent_sourceip                 = undef,
  $agent_enableremotecommands     = '0',
  $agent_logremotecommands        = '0',
  $agent_listenip                 = $::ipaddress,
  $agent_listenport               = '10050',
  $agent_startagents              = '3',
  $agent_hostname                 = $::fqdn,
  $agent_hostnameitem             = 'system.hostname',
  $agent_hostmetadata             = undef,
  $agent_hostmetadataitem         = undef,
  $agent_refreshactivechecks      = '120',
  $agent_buffersend               = '5',
  $agent_buffersize               = '100',
  $agent_maxlinespersecond        = '100',
  $agent_zabbix_alias             = undef,
  $agent_timeout                  = '30',
  $agent_user                     = 'zabbix',
  $agent_unsafeuserparameters     = '0',
  $agent_loadmodulepath           = '${libdir}/modules', #lint:ignore:single_quote_string_with_variables
  $agent_loadmodule               = undef,
  $agent_version                  = $version
) {
  Package {allow_virtual => false}
  if $::osfamily == 'RedHat' {
    case $::operatingsystemrelease {
      /^5.*/: {
        $agent_allowroot = '1'
        $os_release = 'el5'
      }
      /^6.*/: {
        $agent_allowroot = '0'
        $os_release = 'el6'
      }
      /^7.*/: {
        $agent_allowroot = '0'
        $os_release = 'el7'
      }
      default: {
        fail 'Unsupported OS'
      }
    }
  }
  case $::osfamily {
    'RedHat': {
      $version          = '2.4.5'
      $agent_config_dir = '/etc/zabbix'
      $agent_include    = "${agent_config_dir}/zabbix_agentd.d"
      $agent_logfile    = '/var/log/zabbix/zabbix_agentd.log'
      $provider         = 'yum'
      $package_ensure   = "${version}-1.${os_release}"
      $service_name     = 'zabbix-agent'
    }
    'windows': {
      $version          = '2.4.4'
      $agent_config_dir = 'C:/ProgramData/zabbix'
      $agent_include    = "${agent_config_dir}/include"
      $agent_logfile    = 'C:/ProgramData/zabbix/zabbix_agentd.log'
      $provider         = 'chocolatey'
      $package_ensure   = 'present'
      $service_name     = 'Zabbix Agent'
    }
    default: {
      fail 'Unsupported OS'
    }
  }
}
