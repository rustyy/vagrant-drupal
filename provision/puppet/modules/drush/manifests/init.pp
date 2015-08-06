############################################################
# Implements drush class.
############################################################
class drush {
  exec { "composer install drush":
    command     => 'composer global require "drush/drush:7.*"',
    environment => ["COMPOSER_HOME=/usr/local/bin"],
    require     => Exec['install composer']
  }
}
