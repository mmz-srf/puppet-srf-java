# Debian backport repository is needed

class java::debian-openjdk (
  $version            = undef,
  $openjdk_jre_only   = undef,
){

  if $::operatingsystemmajrelease == 7 && $version >= 8 {
    fail("Openjdk 8+ is not available for Debian 7 (wheezy)")
  }

  $package_jre = "openjdk-${version}-jre"
  $package_jdk = "openjdk-${version}-jdk"

  if $openjdk_jre_only {
    package { $package_jre:
      ensure => installed,
    }
  } else {
    package { ["${package_jdk}", "${package_jre}":
      ensure => installed,
    }
  }
}
