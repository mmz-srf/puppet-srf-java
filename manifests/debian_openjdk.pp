# Debian backport repository is needed

class java::debian_openjdk (
  $version            = undef,
  $openjdk_jre_only   = undef,
){
  $packages_jre = "openjdk-${version}-jre"
  $packages_jdk = "openjdk-${version}-jdk"

  $previous_version = $version - 1

  if (versioncmp($facts['os']['distro']['release']['major'], '7') <= 0) {
    notify{"This Java module doesn't work for Debian versions < 8 - Use puppet package command instead, if you really want to use the old version - notify": }
  }
  elsif (versioncmp($facts['os']['distro']['release']['major'], '8') == 0 and versioncmp("${version}", '9') >= 0) {
    fail("This Java module doesn't work for Debian8 (jessie) if you want to use a Java version newer than 8")
  }
  elsif (versioncmp($facts['os']['distro']['release']['major'], '10') >= 0 and versioncmp("${version}", '8') <= 0) {
    fail("This Java module doesn't work for Debian10 (buster and newer versions) if you want to use Java 8 (or older versions)")
  }
  elsif ((versioncmp($facts['os']['distro']['release']['major'], '8') == 0) or (versioncmp($facts['os']['distro']['release']['major'], '9') == 0 and versioncmp("${version}", '9') >= 0))  {
    # Add backports repository
    if !defined(Apt::Source['debian-backports']) {
      apt::source { 'debian-backports':
        location    => 'http://ftp.ch.debian.org/debian',
        release     => "${::lsbdistcodename}-backports",
        repos       => 'main contrib non-free',
        include     => { 'src' => false },
        notify      => Exec['apt_update'],
      }
    }

    # Get Java from backports
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
  else {
    # Get Java from main repository
    if $openjdk_jre_only {
      package { $packages_jre:
        ensure            => installed,
      }->
      package { ["openjdk-${previous_version}-jre-headless", "openjdk-${previous_version}-jre", $packages_jdk]:
        ensure            => absent,
      }
    } else {
      package { [$packages_jre, $packages_jdk]:
        ensure => installed,
      }->
      package { ["openjdk-${previous_version}-jdk-headless", "openjdk-${previous_version}-jdk", "openjdk-${previous_version}-jre-headless", "openjdk-${previous_version}-jre"]:
        ensure            => absent,
      }
    }
  }
}
