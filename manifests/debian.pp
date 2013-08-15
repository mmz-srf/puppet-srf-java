class java::debian {
  include apt
  
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
    release     => "raring",
    repos       => "main",
    key         => "EEA14886",
    key_server  => "keyserver.ubuntu.com",
    include_src => true
  } ->
  file { '/tmp/java.preseed':
    source => 'puppet:///modules/java/java.preseed',
    mode   => '0600',
    backup => false,
  } ->
  package { 'oracle-java7-installer':
    responsefile => '/tmp/java.preseed',
  }
}