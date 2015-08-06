############################################################
# Implements apache2 class.
############################################################

class apache2 {

############################################################
# General setup.
############################################################

# Install apache
  package { 'apache2':
    ensure => present,
  }

# Run apache.
  service { 'apache2':
    ensure  => running,
    require => Package['apache2'],
  }

# User configuration.
  file { 'user.conf':
    ensure  => link,
    path    => '/etc/apache2/conf-available/user.conf',
    target  => '/vagrant/provision/files/apache2/httpd.conf',
  }

  file { '/etc/apache2/conf-enabled/user.conf':
    ensure => link,
    target => '/etc/apache2/conf-available/user.conf',
  }

############################################################
# Apache modules.
############################################################

# Enable rewrite module.
  exec { 'modRewrite enable':
    command => 'sudo a2enmod rewrite',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

# Enable ssl module.
  exec { 'ssl enable':
    command => 'sudo a2enmod ssl',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

############################################################
# Apache sites.
############################################################

# Disable apache default site.
  exec { 'disable apache default':
    command => 'sudo a2dissite 000-default',
    notify  => Service['apache2'],
    require => Package['apache2'],
  }

# Configure default configuration.
  file { 'vagrant.conf':
    ensure  => 'link',
    path    => '/etc/apache2/sites-available/vagrant.conf',
    target  => '/vagrant/provision/files/apache2/sites-available/vagrant.conf',
  }

# Enable vagrant default site.
  exec { 'enable vagrant':
    command => 'sudo a2ensite vagrant',
    notify  => Service['apache2'],
    require => [
      Exec['modRewrite enable'],
      File['vagrant.conf'],
      Package['apache2'],
    ],
  }

# Vagrant ssl.
  file { 'vagrant_ssl.conf':
    ensure => 'link',
    path   => '/etc/apache2/sites-available/vagrant_ssl.conf',
    target => '/vagrant/provision/files/apache2/sites-available/vagrant_ssl.conf',
  }

  exec { 'enable vagrant_ssl':
    command => 'sudo a2ensite vagrant_ssl',
    require => [
      Exec['ssl cert'],
      Package['apache2'],
    ],
  }

############################################################
# Openssl setup.
############################################################

# Generate private key for apache.
  exec { 'apache private key':
    command => 'sudo openssl genrsa -out /etc/ssl/private/apache.key 2048',
  }

# Create ssl certificate.
  exec { 'ssl cert':
    command => 'sudo openssl req -new -x509 -key /etc/ssl/private/apache.key -days 365 -sha256 -out /etc/ssl/certs/apache.crt -subj "/C=DE/ST=HH/L=HH/O=Dis/CN=vagrant-drupal.local"',
    require => Exec['apache private key'],
  }
}
