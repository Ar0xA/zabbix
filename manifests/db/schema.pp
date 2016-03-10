# == Class: zabbix::db::schema
#
# Configures the database schema used by Zabbix and loads the default schema layout
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::db::schema (
  $dbversion                  = $zabbix::db::dbversion,
  $dbhost                     = $zabbix::db::dbhost,
  $dbname                     = $zabbix::db::dbname,
  $dbuser                     = $zabbix::db::dbuser,
  $dbpassword                 = $zabbix::db::dbpassword,
  $dbport                     = $zabbix::db::dbport,
  $zabbix_version             = $zabbix::base::version
) {
  file_line { 'zabbix_pgpass':
    path    => '/var/lib/pgsql/.pgpass',
    line    => "${dbhost}:${dbport}:${dbname}:${dbuser}:${dbpassword}",
    before  => Exec['create_zabbix_schema'],
    require => Class['postgresql::server']
  }
  exec { 'create_zabbix_schema':
    command => "psql --tuples-only --quiet -h ${dbhost} -d ${dbname} -U ${dbuser} -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}/create/schema.sql",
    path    => "/usr/pgsql-${dbversion}/bin",
    user    => 'postgres',
    before  => File['db_schema'],
    creates => '/etc/zabbix/db_schema_created',
    require => [ Package['zabbix-server'], Class['zabbix::db::database'] ]
  }
  exec { 'create_zabbix_images':
    command => "psql --tuples-only --quiet -h ${dbhost} -d ${dbname} -U ${dbuser} -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}/create/images.sql",
    path    => "/usr/pgsql-${dbversion}/bin",
    user    => 'postgres',
    before  => File['db_images'],
    creates => '/etc/zabbix/db_images_created',
    require => Exec['create_zabbix_schema']
  }
  exec { 'create_zabbix_data':
    command => "psql --tuples-only --quiet -h ${dbhost} -d ${dbname} -U ${dbuser} -f /usr/share/doc/zabbix-server-pgsql-${zabbix_version}/create/data.sql",
    path    => "/usr/pgsql-${dbversion}/bin",
    user    => 'postgres',
    before  => File['db_data'],
    creates => '/etc/zabbix/db_data_created',
    require => Exec['create_zabbix_images']
  }
  # Create file to mark initial DB filling as run
  file { 'db_schema':
    ensure  => present,
    path    => '/etc/zabbix/db_schema_created',
    content => '1'
  }
  file { 'db_images':
    ensure  => present,
    path    => '/etc/zabbix/db_images_created',
    content => '1'
  }
  file { 'db_data':
    ensure  => present,
    path    => '/etc/zabbix/db_data_created',
    content => '1'
  }
}
