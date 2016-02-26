# == Class: nfsen
#
# This class installs/configures/manages nfsen.
#
# === Parameters
#
# [*basedir*]
#   String. Base directory for nfsen.
#
# [*bindir*]
#   String. Default '/var/lib/nfsen/bin'
#
# [*libexecdir*]
#   String. Default '/var/lib/nfsen/libexec'
#
# [*confdir*]
#   String. Default '/var/lib/nfsen/etc'
#
# [*htmldir*]
#   String. Default '/var/www/nfsen'
#
# [*docdir*]
#   String. Default '/var/lib/nfsen/doc'
#
# [*vardir*]
#   String. Default '/var/lib/nfsen/var'
#
# [*piddir*]
#   String. Default '/var/lib/nfsen/run'
#
# [*filterdir*]
#   String. Default '/var/lib/nfsen/filters'
#
# [*formatdir*]
#   String. Default '/var/lib/nfsen/fmt',
#
# [*profilestatdir*]
#   String. Default '/var/lib/nfsen/profiles-stat',
#
# [*profiledatadir*]
#   String. Default "#{BASEDIR}/profiles-data',
#
# [*backend_plugindir*]
#   String. Default "#{BASEDIR}/plugins',
#
# [*frontend_plugindir*]
#   String. Default "#{HTMLDIR}/plugins',
#
# [*prefix*]
#   String. Default '/usr/bin',
#
# [*commsocket*]
#   String. Default '/var/lib/nfsen/run/nfsen.comm',
#
# [*user*]
#   String. Default 'netflow',
#
# [*wwwuser*]
#   String. Default 'www-data'
#
# [*wwwgroup*]
#   String. Default 'www-group'
#
# [*bufflen*]
#   Integer. Default 200000 (bytes)
#
# [*extensions*]
#   String. Default 'all'
#
# [*subdirlayout*]
#   Integer. Default 2 (see nfdump/nfsen doc)
#
# [*zipcollected*]
#   Boolean. Default true
#
# [*zipprofiles*]
#   Boolean. Default true
#
# [*profilers*]
#   Integer. Default 2
#
# [*disklimit*]
#   Integer. Default 98
#
# [*low_water*]
#   Integer. Default 90
#
# [*syslog_facility*]
#   String. Default 'local3'
#
# [*mail_from*]
#   String. Default 'your@from.example.net'
#
# [*mail_body*]
#   String. Default 'q{ Alert \'@alert@\' triggered at timeslot @timeslot@ };'
#
# [*sources*]
#   Array of Hashes. See examples.
#
# [*version*]
#   String. Version of nfsen to install when not using a custom repository source
#
# [*custom_repo*]
#   Boolean. Whether to source the NfSen repository from a custom source (via vcsrepo)
#
# [*custom_repo_provider*]
#   String. Custom repositiory provider e.g. git
#
# [*custom_repo_source*]
#   String. Where the custom repository resides
#
# [*web*]
#   Boolean.  Whether to install the secure web frontend
#
# [*web_ssl_verify_client*]
#   String. Apache2 compatible client verify string e.g. none, required
#
# [*web_ssl_verify_depth*]
#   Integer.  Number of (intermediate) CA certificates to verify
#
class nfsen (
  $basedir = '/var/lib/nfsen',
  $bindir = '/var/lib/nfsen/bin',
  $libexecdir = '/var/lib/nfsen/libexec',
  $confdir = '/var/lib/nfsen/etc',
  $htmldir = '/var/www/html/nfsen/',
  $docdir = '/var/lib/nfsen/doc',
  $vardir = '/var/lib/nfsen/var',
  $piddir = '/var/lib/nfsen/run',
  $filterdir = '/var/lib/nfsen/var/filters',
  $formatdir = '/var/lib/nfsen/var/fmt',
  $profilestatdir = '/var/lib/nfsen/profiles-stat',
  $profiledatadir = '/var/lib/nfsen/profiles-data',
  $backend_plugindir = '/var/lib/nfsen/plugins',
  $frontend_plugindir = '/var/www/html/nfsen/plugins',
  $prefix = '/usr/bin',
  $commsocket = '/var/lib/nfsen/run/nfsen.comm',
  $user = 'netflow',
  $wwwuser = 'www-data',
  $wwwgroup = 'www-data',
  $bufflen = 200000,
  $extensions = 'all',
  $subdirlayout = 1,
  $zipcollected = true,
  $zipprofiles = true,
  $profilers = 2,
  $disklimit = 98,
  $low_water = 90,
  $syslog_facility = 'local3',
  $mail_from = "netflow@${::fqdn}",
  $smtp_server = 'localhost',
  $mail_body = 'q{ Alert \'@alert@\' triggered at timeslot @timeslot@ };',
  $sources = [
    {
      'name' => 'all',
      'port' => '9995',
      'col'  => '#0000ff',
      'type' => 'netflow',
    },
  ],
  $version = '1.3.6p1',
  $custom_repo = false,
  $custom_repo_provider = undef,
  $custom_repo_source = undef,
  $web = true,
  $web_ssl_verify_client = 'none',
  $web_ssl_verify_depth = 1,
) {

  include ::nfsen::nfdump
  include ::nfsen::repo
  include ::nfsen::install
  include ::nfsen::configure
  include ::nfsen::service
  include ::nfsen::web

  Class['::nfsen::nfdump'] ->
  Class['::nfsen::repo'] ->
  Class['::nfsen::install'] ->
  Class['::nfsen::configure'] ->
  Class['::nfsen::service'] ->
  Class['::nfsen::web']

}
