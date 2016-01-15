############################################################
# Implements ruby-compass class.
############################################################

class ruby-compass {
  package {
    [
      'ruby-compass',
    ]:
      ensure => present,
  }

  exec { 'gem install compass':
    command => 'gem install compass',
    require => Package['ruby-compass'],
  }


}
