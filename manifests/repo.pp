# == Class: nfsen::repo
#
# Controls the NfSen source
#
class nfsen::repo {

  if $::nfsen::custom_repo {

    # Installs the repo from a customized source e.g. github
    vcsrepo { '/opt/nfsen':
      ensure   => present,
      provider => $::nfsen::custom_repo_provider,
      source   => $::nfsen::custom_repo_source,
    }

  } else {

    # Installs vanilla code from sourceforge (is that still a thing??)
    $_source_uri = 'http://sourceforge.net/projects/nfsen/files/stable'
    $_source_file = "/tmp/nfsen-${::nfsen::version}.tar.gz"

    exec { "wget -q ${_source_uri}/nfsen-${::nfsen::version}/nfsen-${::nfsen::version}.tar.gz -O- > ${_source_file}":
      creates => $_source_file,
    } ~>

    exec { "tar xf ${_source_file} -C /opt --transform 's!^[^/]\\+\\($\\|/\\)!nfsen\\1!'":
      creates => '/opt/nfsen',
    }

  }

}
