class java {
  case $::operatingsystem {
    debian: {

      include apt
      
      file { '/tmp/webupd8team.key':
        ensure => file,
        source => 'puppet:///modules/java/webupd8team.key'
      }->
      exec { "import gpg key webupd8team":
        command => "/bin/cat /tmp/webupd8team.key | apt-key add -",
        unless => "/usr/bin/apt-key list | grep -Fe 'webupd8team' | grep -Fvqe 'expired:'",
        before => Exec['apt_update'],
        notify => Exec['apt_update'],
      }->      
      apt::source { 'webupd8team': 
        location          => "http://ppa.launchpad.net/webupd8team/java/ubuntu",
        release           => "raring",
        repos             => "main",
        key               => "EEA14886",
        key_server        => "keyserver.ubuntu.com",
        include_src       => true
      }
      package { 'oracle-java7-installer':
        responsefile => '/tmp/java.preseed',
        require      => [
                          Apt::Source['webupd8team'],
                          File['/tmp/java.preseed']
                        ],
      }
   }
   default: { notice "Unsupported operatingsystem ${::operatingsystem}" }
 }

  case $::operatingsystem {
    debian: {
      file { '/tmp/java.preseed':
        source => 'puppet:///modules/java/java.preseed',
        mode   => '0600',
        backup => false,
      }
    }
    default: { notice "Unsupported operatingsystem ${::operatingsystem}" }
  }
}


