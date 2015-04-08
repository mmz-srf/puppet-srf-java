class java::debian (
  $version = '7',
){
  include apt

  $package_name = "oracle-java${version}-installer"

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
    release     => "vivid",
    repos       => "main",
    key         => "EEA14886",
    key_server  => "hkp://keyserver.ubuntu.com:80",
    include_src => true
  } ->
  file { '/tmp/java.preseed':
    source => 'puppet:///modules/java/java.preseed',
    mode   => '0600',
    backup => false,
  } ->
  package { $package_name:
    ensure       =>  installed,
    responsefile => '/tmp/java.preseed',
  }
}