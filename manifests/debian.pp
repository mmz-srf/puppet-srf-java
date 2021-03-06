class java::debian (
  $version = '8',
){
  include apt

  $package_name = "oracle-java${version}-installer"
  $package_unlimited_jce = "oracle-java${version}-unlimited-jce-policy"

  file { '/tmp/webupd8team.key':
    ensure => file,
    source => 'puppet:///modules/java/webupd8team.key'
  } ->
  exec { "import gpg key webupd8team":
    command => "/bin/cat /tmp/webupd8team.key | apt-key add -",
    unless  => "/usr/bin/apt-key list | grep -q 'Launchpad VLC'",
    notify  => Class['::apt::update'],
  } ->
  apt::source { 'webupd8team':
    location    => "http://ppa.launchpad.net/webupd8team/java/ubuntu",
    release     => "xenial",
    repos       => "main",
    key         => { 'id'        => "7B2C3B0889BF5709A105D03AC2518248EEA14886",
                     'server'    => "hkp://keyserver.ubuntu.com:80" },
    include     => { 'src'       => true },
  } ->
  file { '/tmp/java.preseed':
    source => 'puppet:///modules/java/java.preseed',
    mode   => '0600',
    backup => false,
  } ->
  package { $package_name:
    ensure       =>  installed,
    responsefile => '/tmp/java.preseed',
  } ->
  package { $package_unlimited_jce:
    ensure => installed,
  }
}
