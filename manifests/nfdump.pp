# == Class: nfsen::nfdump
#
# Class to install and manage nfdump
#
class nfsen::nfdump {

  assert_private()

  ensure_packages('nfdump')

  Package['nfdump'] ->

  # NfSen will control NfDump for us
  service { 'nfdump':
    ensure => stopped,
    enable => false,
  }

}
