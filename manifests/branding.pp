class zabbix::branding (
  $global_ensure          = $zabbix::branding::params::ensure,
  $version                = $zabbix::branding::params::version,
  $branding               = $zabbix::branding::params::branding,
  $page_title             = $zabbix::branding::params::page_title,
  $left_logo_objectname   = $zabbix::branding::params::left_logo_objectname,
  $left_logo_hyperlink    = $zabbix::branding::params::left_logo_hyperlink,
  $center_logo_objectname = $zabbix::branding::params::center_logo_objectname,
  $center_logo_hyperlink  = $zabbix::branding::params::center_logo_hyperlink,
  $favicon                = $zabbix::branding::params::favicon,
  $left_logo_height       = $zabbix::branding::params::left_logo_height,
  $left_logo_width        = $zabbix::branding::params::left_logo_width,
  $left_logo_url          = $zabbix::branding::params::left_logo_url,
  $left_logo_canvas       = $zabbix::branding::params::left_logo_canvas,
  $left_logo_cursor       = $zabbix::branding::params::left_logo_cursor,
  $center_logo_height     = $zabbix::branding::params::center_logo_height,
  $center_logo_width      = $zabbix::branding::params::center_logo_width,
  $center_logo_url        = $zabbix::branding::params::center_logo_url,
  $center_logo_canvas     = $zabbix::branding::params::center_logo_canvas,
  $center_logo_cursor     = $zabbix::branding::params::center_logo_cursor,
  $login_background       = $zabbix::branding::params::login_background,
  $login_logo_height      = $zabbix::branding::params::login_logo_height,
  $login_logo_width       = $zabbix::branding::params::login_logo_width,
  $login_logo_url         = $zabbix::branding::params::login_logo_url,
  $login_logo_add         = $zabbix::branding::params::login_logo_add
) inherits zabbix::branding::params {
  Package {allow_virtual => false}
  file { "/usr/share/zabbix/images/general/${login_background}":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/zabbix/branding/${branding}/${login_background}"
  }
  file { "/usr/share/zabbix/images/general/${login_logo_url}":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/zabbix/branding/${branding}/${login_logo_url}"
  }
  file { "/usr/share/zabbix/images/general/${left_logo_url}":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/zabbix/branding/${branding}/${left_logo_url}"
  }
  file { "/usr/share/zabbix/images/general/${center_logo_url}":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/zabbix/branding/${branding}/${center_logo_url}"
  }
  file { "/usr/share/zabbix/images/general/${favicon}":
    ensure => present,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => "puppet:///modules/zabbix/branding/${branding}/${favicon}"
  }
  file { '/usr/share/zabbix/include/page_header.php':
    ensure  => $global_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    content => template("zabbix/${version}/branding/page_header.php.erb")
  }
  file { '/usr/share/zabbix/include/views/general.browserwarning.php':
    ensure  => $global_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    content => template("zabbix/${version}/branding/general.browserwarning.php.erb")
  }
  file { '/usr/share/zabbix/include/classes/html/pageheader/CPageHeader.php':
    ensure  => $global_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    content => template("zabbix/${version}/branding/CPageHeader.php.erb")
  }
  file { '/usr/share/zabbix/styles/icon.css':
    ensure  => $global_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    content => template("zabbix/${version}/branding/icon.css.erb")
  }
  file { '/usr/share/zabbix/styles/default.css':
    ensure  => $global_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    content => template("zabbix/${version}/branding/default.css.erb")
  }
  file { '/usr/share/zabbix/styles/pages.css':
    ensure  => $global_ensure,
    owner   => root,
    group   => root,
    mode    => '0644',
    replace => true,
    content => template("zabbix/${version}/branding/pages.css.erb")
  }
}
