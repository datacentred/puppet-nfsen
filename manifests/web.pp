# == Class: nfsen::web
#
# Installs the web frontend
#
class nfsen::web {

  assert_private()

  if $::nfsen::web {

    include ::apache
    include ::apache::mod::php
    include ::apache::mod::ssl

    if versioncmp($::puppetversion, '4.0.0') >= 0 {
      $_ssldir = '/etc/puppetlabs/puppet/ssl'
    } else {
      $_ssldir = '/var/lib/puppet/ssl'
    }

    apache::vhost { 'nfsen':
      servername      => $::fqdn,
      port            => 80,
      docroot         => '/var/www/html',
      redirect_status => 'permanent',
      redirect_dest   => "https://${::fqdn}",
    } ->

    apache::vhost { 'nfsen_ssl':
      servername        => $::fqdn,
      port              => 443,
      docroot           => '/var/www/html',
      ssl               => true,
      ssl_cert          => "${_ssldir}/certs/${::fqdn}.pem",
      ssl_key           => "${_ssldir}/private_keys/${::fqdn}.pem",
      ssl_ca            => "${_ssldir}/certs/ca.pem",
      ssl_crl           => "${_ssldir}/crl.pem",
      ssl_verify_client => $::nfsen::web_ssl_verify_client,
      ssl_verify_depth  => $::nfsen::web_ssl_verify_depth,
    } ->

    # Link in the web frontend
    file { "${::nfsen::htmldir}/index.php":
      ensure => link,
      target => "${::nfsen::htmldir}/nfsen.php",
    }

  }

}
