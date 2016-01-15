# Run apt update first.
exec { 'apt update':
  command => 'apt-get update',
  path    => '/usr/bin'
}

# Set global path variable for project
# http://www.puppetcookbook.com/posts/set-global-exec-path.html
Exec { path => [ "/bin",
  "/sbin",
  "/usr/bin",
  "/usr/sbin",
  "/usr/local/bin",
  "/usr/local/sbin",
  "~/.composer/vendor/bin"
] }

# Install all the software we need.
class { 'apache2': }
class { 'php5': }
class { 'mysql': }
class { 'phpmyadmin': }
class { 'composer': }
class { 'drush': }
class { 'ruby-compass': }
