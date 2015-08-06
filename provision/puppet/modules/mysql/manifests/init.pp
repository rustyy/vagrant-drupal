############################################################
# Implements mysql class.
############################################################

class mysql {
# Set some variables to be used.
# @Todo: Provide params for this.
  $password = 'vagrant'
  $remote_root_sql ="GRANT ALL ON *.* TO 'root'@'%' IDENTIFIED BY '${password}' WITH GRANT OPTION;"

# MySQL server and client to be installed.
  package {
    [
      'mysql-client',
      'mysql-server',
    ]:
      ensure => installed,
  }

# Set root password as defined.
  exec { 'mysql root password':
    subscribe   => [
      Package['mysql-server'],
      Package['mysql-client'],
    ],
    refreshonly => true,
    unless      => "mysqladmin -uroot -p${password} status",
    command     => "mysqladmin -uroot password ${password}",
  }

# Permit remote access to the server.
  exec { 'remote root':
    require => Exec['mysql root password'],
    command => "mysql -uroot -p${password} -e \"${remote_root_sql}\"",
  }

# Initiate the mysql service.
  service { 'mysql':
    ensure  => running,
  }

# Mysql configuration.
  file { 'vagrant.cnf':
    ensure  => 'present',
    path    => '/etc/mysql/conf.d/vagrant.cnf',
    source  => 'file:///vagrant/provision/files/mysql/vagrant.cnf',
    require => Package['mysql-server'],
    mode    => 644,
    notify  => Service['mysql'],
  }
}
