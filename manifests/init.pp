class java {
  case $::operatingsystem {
    debian: {
      include java::debian
    }
    default: {
      notice "Unsupported operatingsystem ${::operatingsystem}"
    }
  }
}
