# == Class: nfsen::configure
#
# Configures the nfsen service
#
class nfsen::configure {

  assert_private()

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

  # Apache ($::nfsen::wwwgroup) is implicitly installed with php5
  user { $_user:
    ensure => 'present',
    groups => $_wwwgroup,
  } ->

  file { '/opt/nfsen/etc/nfsen.conf':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => template('nfsen/nfsen.conf.erb'),
  } ->

  # Prompts for perl path *sigh*
  # TODO: perhaps 'echo ${perl_path}' rather than 'yes'
  exec { 'yes "" | /opt/nfsen/install.pl etc/nfsen.conf':
    cwd     => '/opt/nfsen',
    creates => $_basedir,
  }

}
