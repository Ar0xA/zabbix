# == Class: zabbix::db::tablespace
#
# Configures the database tablespace used by Zabbix
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::db::tablespaces (
  $datadir                    = $zabbix::db::datadir,
  $instancename               = $zabbix::db::instancename,
  $dbname                     = $zabbix::db::dbname,
) {
  postgresql::server::tablespace { "${dbname}_table":
    location => "${datadir}/${instancename}/pgdata/pg_tblspc/${dbname}_table",
    owner    => 'zabbix',
    before   => Class['zabbix::db::database'],
  }
  postgresql::server::tablespace { "${dbname}_index":
    location => "${datadir}/${instancename}/pgdata/pg_tblspc/${dbname}_index",
    owner    => 'zabbix',
    before   => Class['zabbix::db::database'],
  }
}
