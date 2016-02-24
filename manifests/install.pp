# == Class: nfsen::install
#
# Installs requisite packages
#
class nfsen::install {

  assert_private()

  $packages = [
    'git',
    'libmailtools-perl',
    'librrds-perl',
    'perl',
    'php5',
    'rrdtool',
  ]

  ensure_packages($packages)

}
