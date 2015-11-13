############################################################
# Implements php class.
############################################################

class php5 {
  package {
    [
      'php5',
      'php5-mysql',
      'php5-curl',
      'php5-gd',
      'php5-fpm',
      'libapache2-mod-php5',
      'php5-dev',
      'php5-xdebug',
      'php5-mcrypt',
    ]:
      ensure => present,
  }

  exec { 'php5-mcrypt':
    command => 'php5enmod mcrypt',
    require => Package['php5'],
  }

  file { 'php.ini':
    ensure  => 'link',
    path    => '/etc/php5/apache2/conf.d/vagrant_php.ini',
    require => Package['php5'],
    target  => '/vagrant/provision/files/php5/php.ini',
  }

  file { 'php.ini cli':
    ensure  => 'link',
    path    => '/etc/php5/cli/conf.d/vagrant_php.ini',
    require => Package['php5'],
    target  => '/vagrant/provision/files/php5/php.ini',
  }

  file { 'xdebug.ini':
    ensure  => 'link',
    path    => '/etc/php5/apache2/conf.d/xdebug.ini',
    require => Package['php5'],
    target  => '/vagrant/provision/files/php5/xdebug.ini',
  }
}
