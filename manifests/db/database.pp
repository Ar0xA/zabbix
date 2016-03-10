# == Class: zabbix::db::database
#
# Configures the name of the database used by zabbix
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::db::database (
  $dbname                     = $zabbix::db::dbname,
  $dbuser                     = $zabbix::db::dbuser,
) {
  postgresql::server::database { $dbname:
    owner      => $dbuser,
    tablespace => "${dbname}_table",
  }
}
