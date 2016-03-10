class zabbix::templates {
  package { 'python-lxml':
    ensure => present
  }
  file { '/tmp/zabbix_templates':
    ensure  => directory,
    source  => 'puppet:///modules/zabbix/zabbix_templates',
    recurse => true,
    purge   => true
  }
  exec { 'import_zabbix_templates':
    command => 'importTemplates.py',
    cwd     => '/tmp/zabbix_templates',
    path    => '/tmp/zabbix_templates',
    before  => File['templates_imported'],
    creates => '/etc/zabbix/templates_imported',
    require => [ File['/tmp/zabbix_templates'], Package['python-lxml'] ]
  }
  file { 'templates_imported':
    ensure  => present,
    path    => '/etc/zabbix/templates_imported',
    content => '1'
  }
}
