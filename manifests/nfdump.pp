# == Class: nfsen::nfdump
#
# Class to install and manage nfdump
#
class nfsen::nfdump {

  assert_private()

  $packages = [
    'gcc',
    'make',
    'flex',
    'librrd-dev',
  ]

  ensure_packages($packages)

  # Installs vanilla code from sourceforge (is that still a thing??)
  $_source_uri = 'http://sourceforge.net/projects/nfdump/files/stable'
  $_source_file = "/tmp/nfdump-${::nfsen::nfdump_version}.tar.gz"
  $_source_dir = "/tmp/nfdump-${::nfsen::nfdump_version}"

  Package[$packages] ->

  exec { 'nfdump fetch':
    command => "wget -q ${_source_uri}/nfdump-${::nfsen::nfdump_version}/nfdump-${::nfsen::nfdump_version}.tar.gz -O- > ${_source_file}",
    creates => $_source_file,
  } ->

  exec { 'nfdump extract':
    command => "tar xf ${_source_file}",
    creates => $_source_dir,
    cwd     => '/tmp',
  } ->

  exec { 'nfdump configure':
    command => "${_source_dir}/configure --enable-nfprofile",
    creates => "${_source_dir}/Makefile",
    cwd     => $_source_dir,
  } ->

  exec { 'nfdump make':
    command => 'make',
    creates => "${_source_dir}/bin/nfdump",
    cwd     => $_source_dir,
  } ->

  exec { 'nfdump make install':
    command => 'make install',
    creates => '/usr/local/bin/nfdump',
    cwd     => $_source_dir,
  }

}
