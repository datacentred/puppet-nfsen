# == Class: nfsen::service
#
# Ensures the nfsen service is running
#
class nfsen::service {

  assert_private()

  service { 'nfsen':
    ensure    => 'running',
    hasstatus => false,
    path      => "${::nfsen::basedir}/bin",
    pattern   => "${::nfsen::basedir}/bin/nfsend"
  }

}
