class java (
  $version = '8',
  $distribution = undef, # this parameter is just for compatibility https://forge.puppetlabs.com/puppetlabs/java
){
  case $::operatingsystem {
    debian: {

      class {'java::debian':
        version => $version,
      }

    }
    default: {
      notice "Unsupported operatingsystem ${::operatingsystem}"
    }
  }
}
