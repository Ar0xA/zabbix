# == Class: zabbix::db
#
# Install everything needed by zabbix_server to use a PostgreSQL database backend
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::db (
  $datadir                    = $zabbix::params::datadir,
  $instancename               = $zabbix::params::instancename,
  $dbversion                  = $zabbix::params::dbversion,
  $dbhost                     = $zabbix::params::server_dbhost,
  $dbport                     = $zabbix::params::server_dbport,
  $dbname                     = $zabbix::params::server_dbname,
  $dbuser                     = $zabbix::params::server_dbuser,
  $dbpassword                 = $zabbix::params::server_dbpassword
) {
  $iptable_entries = {
    '200 PostgreSQL DB' => {
      chain  => $::input_chain_name,
      proto  => 'tcp',
      action => 'accept',
      dport  => $dbport
    }
  }
#  class { 'zabbix::db::env': }
  class { 'zabbix::db::role': }
  class { 'zabbix::db::tablespaces': }
  class { 'zabbix::db::database': }
  class { 'zabbix::db::schema': }

  class { 'postgresql::globals':
    manage_package_repo => true,
    version             => $dbversion,
    datadir             => "${datadir}/${instancename}/pgdata",
  }->
  class { 'postgresql::server':
    require           => Class['zabbix::db::env'],
    before            => Class['zabbix::db::role'],
    postgres_password => 'postgres',
    listen_addresses  => '*'
  }
  postgresql::server::pg_hba_rule { 'allow beheer network to access zabbix database':
    description => "Open up postgresql for access from 10.4.6.0/24",
    type => 'host',
    database => 'zabbix',
    user => 'zabbix',
    address => '10.4.6.0/24',
    auth_method => 'trust'
  }
  file { '/var/lib/pgsql/.pgsql_profile':
    content => template('zabbix/db/pgsql_profile.erb'),
    owner   => postgres,
    group   => postgres,
    require => Class['postgresql::server']
  }
  file { '/var/lib/pgsql/.bashrc':
    source  => 'puppet:///modules/zabbix/db/bashrc',
    owner   => postgres,
    group   => postgres,
    require => Class['postgresql::server']
  }
  create_resources('firewall', $iptable_entries)
}
