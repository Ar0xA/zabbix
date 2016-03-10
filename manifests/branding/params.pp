class zabbix::branding::params (
  $branding = 'zabbix',
  $version  = $zabbix::params::version
) inherits zabbix::params {
  Package {allow_virtual => false}
  case $branding {
    'zabbix': {
      #page_header.php
      $page_title             = 'Zabbix'
      $left_logo_objectname   = 'zabbix_logo'
      $left_logo_hyperlink    = 'http://www.zabbix.com/'
      #general.browserwarning.php and CPageHeader.php
      $favicon                = 'zabbix.ico'
      #icon.css
      $left_logo_height       = '31px'
      $left_logo_width        = '118px'
      $left_logo_url          = 'zabbix.png'
      $left_logo_canvas       = undef
      $left_logo_cursor       = 'pointer'
      #pages.css
      $login_background       = 'login/background.png'
      $login_logo_height      = '51px'
      $login_logo_width       = '162px'
      $login_logo_url         = 'login/logo.png'
    }
    'vermont': {
      #page_header.php
      $page_title             = 'MIOS'
      $left_logo_objectname   = 'mios_logo'
      $left_logo_hyperlink    = 'http://en.wikipedia.org/wiki/Mios'
      $center_logo_objectname = 'makesitfit_logo'
      $center_logo_hyperlink  = 'http://www.vermont24-7.com/servicestack/'
      #general.browserwarning.php and CPageHeader.php
      $favicon                = 'vermont24-7_logo.ico'
      #icon.css
      $left_logo_height       = '69px'
      $left_logo_width        = '220px'
      $left_logo_url          = 'mios_logo_small.png'
      $left_logo_canvas       = '220px'
      $left_logo_cursor       = 'pointer'
      $center_logo_height     = '59px'
      $center_logo_width      = '300px'
      $center_logo_url        = 'vermont_makesitfit.png'
      $center_logo_canvas     = '220px'
      $center_logo_cursor     = 'pointer'
      #pages.css
      $login_background       = 'login/mios_background.png'
      $login_logo_height      = '53px'
      $login_logo_width       = '163px'
      $login_logo_url         = 'login/mios_logo.png'
      $login_logo_add         = 'background-size:175px;'
    }
    'prorail': {
      #page_header.php
      $page_title             = 'Zabbix'
      $left_logo_objectname   = 'prorail_logo'
      $left_logo_hyperlink    = 'http://www.prorail.nl/'
      #general.browserwarning.php and CPageHeader.php
      $favicon                = 'prorail.ico'
      #icon.css
      $left_logo_height       = '69px'
      $left_logo_width        = '220px'
      $left_logo_url          = 'prorail_logo.png'
      $left_logo_canvas       = '220px'
      $left_logo_cursor       = 'pointer'
      #pages.css
      $login_background       = 'login/prorail_background.png'
      $login_logo_height      = '53px'
      $login_logo_width       = '163px'
      $login_logo_url         = 'login/prorail_logo.png'
      $login_logo_add         = 'background-size:160px;'
    }
    'conclusion': {
      #page_header.php
      $page_title             = 'MIOS'
      $left_logo_objectname   = 'mios_logo'
      $left_logo_hyperlink    = 'http://en.wikipedia.org/wiki/Mios'
      $center_logo_objectname = 'conclusion_logo' 
      $center_logo_hyperlink  = 'http://www.conclusion.nl/nl-nl/our-services/mission-critical-services/'
      #general.browserwarning.php and CPageHeader.php
      $favicon                = 'conclusion.ico'
      #icon.css
      $left_logo_height       = '69px'
      $left_logo_width        = '118px'
#      $left_logo_url          = 'mios_logo_small.png'
      $left_logo_url          = 'zabbix.png'
      $left_logo_canvas       = '118px'
      $left_logo_cursor       = 'pointer'
      $center_logo_height     = '59px'
      $center_logo_width      = '300px'
      $center_logo_url        = 'conclusion.png'
      $center_logo_canvas     = '220px'
      $center_logo_cursor     = 'pointer'
      #pages.css
      $login_background       = 'login/background.png'
      $login_logo_height      = '53px'
      $login_logo_width       = '163px'
      $login_logo_url         = 'login/mios_logo.png'
      $login_logo_add         = 'background-size:175px;'
    }
    default: {
      fail "No branding specified. Valid options are: 'zabbix', 'vermont', 'prorail', 'conclusion'"
    }
  }
}
