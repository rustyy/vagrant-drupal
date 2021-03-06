##
# Install composer
##
class composer {
  package { "curl":
    ensure => installed,
  }

  exec { 'install composer':
    command => 'curl -sS https://getcomposer.org/installer | php && sudo mv composer.phar /usr/local/bin/composer',
    require => Package['curl'],
    environment => ["COMPOSER_HOME=/usr/local/bin"],
  }
}
