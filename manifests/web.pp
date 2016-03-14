# == Class: zabbix::web
#
# Install zabbix-web frontend with base configuration
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
class zabbix::web (
  $listenport                 = $zabbix::params::server_listenport,
  $dbhost                     = $zabbix::params::server_dbhost,
  $dbname                     = $zabbix::params::server_dbname,
  $dbschema                   = $zabbix::params::server_dbschema,
  $dbuser                     = $zabbix::params::server_dbuser,
  $dbpassword                 = $zabbix::params::server_dbpassword,
  $dbsocket                   = $zabbix::params::server_dbsocket,
  $dbport                     = $zabbix::params::server_dbport,
  $version                    = $zabbix::params::version
) {
  case $::operatingsystemrelease {
    /^5.*/: {
      $os_release = 'el5'
    }
    /^6.*/: {
      $os_release = 'el6'
    }
    /^7.*/: {
      $os_release = 'el7'
    }
    default: {
      fail 'Unsupported OS'
    }
  }
  $iptable_entries = {
    '200 Zabbix web' => {
      chain  => $::input_chain_name,
      proto  => 'tcp',
      action => 'accept',
      dport  => [ 80, 443 ]
    }
  }

  package { 'httpd':
    ensure => present
  }
  $zabbix_web_additiontal_packages = [ 'php', 'php-bcmath', 'php-gd', 'php-mbstring', 'php-xml', 'php-pdo', 'php-pgsql' ]
  package { $zabbix_web_additiontal_packages:
    ensure => present
  }
  package { 'zabbix-web':
    ensure          => "${version}-1.${os_release}",
    require         => Package[$zabbix_web_additiontal_packages]
  }
  package { 'zabbix-web-pgsql':
    ensure          => "${version}-1.${os_release}",
    require         => [ Package['zabbix-web'], Class['zabbix::base'] ]
  }
  service { 'httpd':
    ensure  => running,
    enable  => true,
    require => File_line['PHP timezone']
  }
  file_line { 'PHP timezone':
    path    => '/etc/php.ini',
    line    => 'date.timezone = Europe/Amsterdam',
    match   => 'date.timezone =.*$',
    require => File['zabbix.conf.php']
  }
  file { 'zabbix.conf.php':
    path    => '/etc/zabbix/web/zabbix.conf.php',
    owner   => apache,
    group   => apache,
    mode    => '0644',
    content => "<?php\n \
      global \$DB;\n\n \
      \$DB['TYPE']     = 'POSTGRESQL';\n \
      \$DB['SERVER']   = '${dbhost}';\n \
      \$DB['PORT']     = '${dbport}';\n \
      \$DB['DATABASE'] = '${dbname}';\n \
      \$DB['USER']     = '${dbuser}';\n \
      \$DB['PASSWORD'] = '${dbpassword}';\n\n \
      \$ZBX_SERVER      = 'localhost';\n \
      \$ZBX_SERVER_PORT = '${listenport}';\n \
      \$ZBX_SERVER_NAME = 'Zabbix server';\n\n \
      \$IMAGE_FORMAT_DEFAULT = IMAGE_FORMAT_PNG;\n?>\n",
    require => Package['zabbix-web-pgsql']
  }
  selboolean { 'httpd_can_network_connect':
    persistent => true,
    value      => 'on',
    require    => Package['httpd']
  }
  selboolean { 'httpd_can_network_connect_db':
    persistent => true,
    value      => 'on',
    require    => Package['httpd']
  }
  create_resources('firewall', $iptable_entries)
}
