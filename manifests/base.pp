# == Class: zabbix::base
#
# Install zabbix base files needed for every Zabbix component
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
class zabbix::base (
  $version = $zabbix::params::version
) inherits zabbix::params {

# Only include the repo class if it has not yet been included
  unless defined(Class['Zabbix::Repo']) {
    class { '::zabbix::repo':
      zabbix_version => $zabbix_version,
      manage_repo    => $manage_repo,
    }
  }
  case $::kernel {
    'Linux': {
      package { 'zabbix':
        ensure  => "${version}-1.${os_release}",
        require => Class['zabbix::repo']
      }
    }
  }
}
