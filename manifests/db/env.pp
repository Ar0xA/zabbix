# == Class: zabbix::db::env
#
# Configures the environment used by Zabbix
#
# === Parameters
#
# === Variables
#
# === Authors
#
# Fabian van der Hoeven <fabian.vanderhoeven@vermont24-7.com>
#
class zabbix::db::env (
  $datadir                    = $zabbix::params::datadir,
  $instancename               = $zabbix::params::instancename,
) inherits zabbix::params {
  group { 'mios':
    ensure => present,
    gid    => 400
  }
  user { 'mios':
    ensure     => present,
    uid        => 400,
    gid        => 400,
    home       => '/opt/mios',
    managehome => true,
    require    => Group['mios']
  }
  file { $datadir:
    ensure  => directory,
    owner   => 'mios',
    group   => 'mios',
    mode    => '0755',
    require => User['mios']
  }
  file { "${datadir}/${instancename}":
    ensure  => directory,
    owner   => 'mios',
    group   => 'mios',
    mode    => '0775',
    require => Class['lvm']
  }
  if $is_virtual == true {
    if $virtual == 'virtualbox' {
      $db_disk="/dev/sdb"
    } else {
      $db_disk="/dev/vdb"
    }
  } else {
    $db_disk="/dev/sdb"
  }
  class {'lvm':
    volume_groups => {
      'vg_database' => {
        physical_volumes => [$db_disk],
        logical_volumes  => {
          'database' => {
            'size'              => '99G',
            'mountpath'         => '/database',
            'mountpath_require' => true,
          },
        },
      },
    },
    require => File[$datadir]
  }
}
