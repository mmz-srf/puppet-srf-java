# Debian backport repository is needed

class java::debian-openjdk (
  $version            = undef,
  $openjdk_jre_only   = undef,
){
  $packages_jre = "openjdk-${version}-jre"
  $packages_jdk = "openjdk-${version}-jdk"

  if $::operatingsystemmajrelease <= 7 {
    notify{"This Java module doesn't work for Debian versions < 8 - Use puppet package command instead, if you really want to use the old version - notify": }
  } else {
    if $openjdk_jre_only {
      package { $packages_jre:
        ensure            => installed,
        install_options   => ["-t","${::lsbdistcodename}-backports", "-f"],
      }
      if $version >= 8 {
        package { ['openjdk-7-jre-headless', 'openjdk-7-jre']:
          ensure            => absent,
        }
      }
    } else {
      package { $packages_jdk:
        ensure => installed,
      }
    }
  }
}
