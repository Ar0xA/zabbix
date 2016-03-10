# == Class: zabbix::db::role
#
# Configures the database role used by Zabbix
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::db::role (
  $dbuser                     = $zabbix::db::dbuser,
  $dbpassword                 = $zabbix::db::dbpassword,
) {
  postgresql::server::role { $dbuser:
    password_hash => postgresql_password($dbuser, $dbpassword),
    before        => Class['zabbix::db::tablespaces'],
  }
}
