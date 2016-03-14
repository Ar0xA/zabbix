# == Class: zabbix::agent
#
# This class takes care of installing and configuring
# the zabbix-agent.
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
#  include zabbix::agent
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#


class zabbix::agent (
  $pidfile                    = $zabbix::params::agent_pidfile,
  $logfile                    = $zabbix::params::agent_logfile,
  $logfilesize                = $zabbix::params::agent_logfilesize,
  $debuglevel                 = $zabbix::params::agent_debuglevel,
  $sourceip                   = $zabbix::params::agent_sourceip,
  $enableremotecommands       = $zabbix::params::agent_enableremotecommands,
  $logremotecommands          = $zabbix::params::agent_logremotecommands,
  $server                     = $zabbix::params::server_ip,
  $listenport                 = $zabbix::params::agent_listenport,
  $listenip                   = $zabbix::params::agent_listenip,
  $startagents                = $zabbix::params::agent_startagents,
  $serveractive               = $server,
  $hostname                   = $zabbix::params::agent_hostname,
  $hostnameitem               = $zabbix::params::agent_hostnameitem,
  $hostmetadata               = $zabbix::params::agent_hostmetadata,
  $hostmetadataitem           = $zabbix::params::agent_hostmetadataitem,
  $refreshactivechecks        = $zabbix::params::agent_refreshactivechecks,
  $buffersend                 = $zabbix::params::agent_buffersend,
  $buffersize                 = $zabbix::params::agent_buffersize,
  $maxlinespersecond          = $zabbix::params::agent_maxlinespersecond,
  $zabbix_alias               = $zabbix::params::agent_zabbix_alias,
  $timeout                    = $zabbix::params::agent_timeout,
  $allowroot                  = $zabbix::params::agent_allowroot,
  $user                       = $zabbix::params::agent_user,
  $include_dir                = $zabbix::params::agent_include,
  $unsafeuserparameters       = $zabbix::params::agent_unsafeuserparameters,
  $loadmodulepath             = $zabbix::params::agent_loadmodulepath,
  $loadmodule                 = $zabbix::params::agent_loadmodule,
  $version                    = $zabbix::base::version,
  $os_release                 = $zabbix::params::os_release,
  $config_dir                 = $zabbix::params::agent_config_dir,
  $package_ensure             = $zabbix::params::package_ensure,
  $service_name               = $zabbix::params::service_name,
  $provider                   = $zabbix::params::provider
) {

  Package {allow_virtual => false}
  package { 'zabbix-agent':
    ensure   => $package_ensure,
    provider => $provider,
    require  => Class['zabbix::base']
  }
  service { $service_name:
    ensure     => running,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    require    => Package['zabbix-agent'],
    subscribe  => [ File["${config_dir}/zabbix_agentd.conf"], File[$include_dir] ]
  }
  file { "${config_dir}/zabbix_agentd.conf":
    ensure  => present,
    require => Package['zabbix-agent'],
    replace => true,
    content => template("zabbix/${version}/${::osfamily}/zabbix_agentd.conf.erb")
  }
  file { $include_dir:
    ensure  => directory,
    source  => "puppet:///modules/zabbix/agent/${::osfamily}",
    recurse => true,
    purge   => true,
    require => Package['zabbix-agent'],
  }
  case $::osfamily {
    'RedHat': {
      file { "${include_dir}/scripts/device_mapper_diskstats.sh":
        ensure  => present,
        mode    => '0755',
        owner   => 'zabbix',
        group   => 'zabbix',
        source  => "puppet:///modules/zabbix/agent/${::osfamily}/scripts/device_mapper_diskstats_rh${os_release}.sh",
        require => Package['zabbix-agent'],
      }
      $iptable_entries = {
        '200 Zabbix agent' => {
          chain  => $::input_chain_name,
          proto  => 'tcp',
          action => 'accept',
          dport  => $listenport,
        }
      }
      create_resources('firewall', $iptable_entries)
    }
    'windows': {
      windows_firewall::exception { 'Zabbix-agent':
        ensure       => present,
        direction    => 'in',
        action       => 'Allow',
        enabled      => 'yes',
        protocol     => 'TCP',
        local_port   => $listenport,
        display_name => 'Zabbix-agent-In',
        description  => "Inbound rule to allow Zabbix-server to connect to the Zabbix-agent on port ${listenport}",
      }
    }
  }
}
