# == Class: nfsen::configure
#
# Configures the nfsen service
#
class nfsen::configure {

  assert_private()

  include ::nfdump

  # Used by nfsen.conf
  $_basedir = $::nfsen::basedir
  $_bindir = $::nfsen::bindir
  $_libexecdir = $::nfsen::libexecdir
  $_confdir = $::nfsen::confdir
  $_htmldir = $::nfsen::htmldir
  $_docdir = $::nfsen::docdir
  $_vardir = $::nfsen::vardir
  $_piddir = $::nfsen::piddir
  $_filterdir = $::nfsen::filterdir
  $_formatdir = $::nfsen::formatdir
  $_profilestatdir = $::nfsen::profilestatdir
  $_profiledatadir = $::nfsen::profiledatadir
  $_backend_plugindir = $::nfsen::backend_plugindir
  $_frontend_plugindir = $::nfsen::frontend_plugindir
  $_prefix = $::nfsen::prefix
  $_commsocket = $::nfsen::commsocket
  $_user = $::nfsen::user
  $_wwwuser = $::nfsen::wwwuser
  $_wwwgroup = $::nfsen::wwwgroup
  $_bufflen = $::nfsen::bufflen
  $_extensions = $::nfsen::extensions
  $_subdirlayout = $::nfsen::subdirlayout
  $_zipcollected = $::nfsen::zipcollected
  $_zipprofiles = $::nfsen::zipprofiles
  $_profilers = $::nfsen::profilers
  $_disklimit = $::nfsen::disklimit
  $_sources = $::nfsen::sources
  $_low_water = $::nfsen::low_water
  $_syslog_facility = $::nfsen::syslog_facility
  $_mail_from = $::nfsen::mail_from
  $_smtp_server = $::nfsen::smtp_server
  $_mail_body = $::nfsen::mail_body

  # Create the ramdisk after creating the user and before any other
  # configuration
  if $::nfsen::use_ramdisk {

    User[$_user] ->

    # nfsen need to write, apache need to read
    file { $_profiledatadir:
      ensure => 'directory',
      owner  => $_user,
      group  => $_wwwgroup,
      mode   => '0755',
    } ->

    mount { $_profiledatadir:
      ensure  => mounted,
      atboot  => true,
      device  => 'ramdisk',
      fstype  => 'tmpfs',
      options => "nodev,nosuid,size=${::nfsen::ramdisk_size}",
    } ->

    Vcsrepo['/opt/nfsen']

  }

  # Apache ($::nfsen::wwwgroup) is implicitly installed with php5
  user { $_user:
    ensure => 'present',
    groups => $_wwwgroup,
  } ->

  # Install the source, configure and install the application
  vcsrepo { '/opt/nfsen':
    ensure   => present,
    provider => 'git',
    source   => 'git://github.com/millingworth/nfsen.git',
  } ->

  file { '/opt/nfsen/etc/nfsen.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nfsen/nfsen.conf.erb'),
  } ->

  exec { 'install':
    command   => 'install.pl /opt/nfsen/etc/nfsen.conf',
    cwd       => '/opt/nfsen',
    logoutput => 'on_failure',
    onlyif    => "test ! -d ${_basedir} || test ! -d ${_htmldir}",
    path      => '/usr/bin:/opt/nfsen',
  } ->

  # Keep the configuration up to date in the installed version of nfsen
  file { "${_basedir}/etc/nfsen.conf":
    ensure  => file,
    content => template('nfsen/nfsen.conf.erb'),
  } ~>

  exec { 'nfsen-reconfig':
    command     => 'nfsen reconfig',
    path        => "/usr/bin:${_basedir}/bin",
    refreshonly => true,
  }

}
