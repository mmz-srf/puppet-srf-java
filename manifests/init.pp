class java (
  $version              = '8',
  $distribution         = undef, # this parameter is just for compatibility https://forge.puppetlabs.com/puppetlabs/java
  $use_openjdk          = false,
  $openjdk_jre_only     = true,
){
  case $::operatingsystem {
    debian: {
      if $use_openjdk {
        class {'java::debian-openjdk':
          version             => $version,
          openjdk_jre_only    => $openjdk_jre_only,
        }
      } else {
        class {'java::debian':
          version => $version,
        }
        if $java_version >= 8 and !defined(Package['ammonite']) {
          package { 'ammonite':
            ensure => installed,
          }
        }
      }
    }
    default: {
      notice "Unsupported operatingsystem ${::operatingsystem}"
    }
  }
}
