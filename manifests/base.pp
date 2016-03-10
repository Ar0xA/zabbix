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

#  package { 'zabbix':
#    ensure   => "${version}-1.${os_release}"
#  }
}
