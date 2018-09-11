# Debian backport repository is needed

class java::debian_openjdk (
  $version            = undef,
  $openjdk_jre_only   = undef,
){
  $packages_jre = "openjdk-${version}-jre"
  $packages_jdk = "openjdk-${version}-jdk"

  $previous_version = $version - 1

  if $::operatingsystemmajrelease <= '7' {
    notify{"This Java module doesn't work for Debian versions < 8 - Use puppet package command instead, if you really want to use the old version - notify": }
  } else {
    if $openjdk_jre_only {
      package { $packages_jre:
        ensure            => installed,
        install_options   => ["-t","${::lsbdistcodename}-backports", "-f"],
      }->
      package { ["openjdk-${previous_version}-jre-headless", "openjdk-${previous_version}-jre", $packages_jdk]:
        ensure            => absent,
      }
    } else {
      package { [$packages_jre, $packages_jdk]:
        ensure => installed,
        install_options   => ["-t","${::lsbdistcodename}-backports", "-f"],
      }->
      package { ["openjdk-${previous_version}-jdk-headless", "openjdk-${previous_version}-jdk", "openjdk-${previous_version}-jre-headless", "openjdk-${previous_version}-jre"]:
        ensure            => absent,
      }
    }
  }
}
