# NfSen

[![Build Status](https://travis-ci.org/datacentred/puppet-nfsen.png?branch=master)](https://travis-ci.org/datacentred/puppet-nfsen)

#### Table Of Contents

1. [Overview](#overview)
2. [Module Description](#module-description)
3. [Setup - The basics of getting started with nfsen](#setup)
    * [Setup Requirements](#setup-requirements)
4. [Usage](#usage)
5. [Limitations](#limitations)

## Overview

Installs NfSen

## Module Description

Installs nfdump and additional pre-requisite packages, clones the nfsen
repository, configures and installs the application.  Optionally installs
an SSL secured web frontend with optional X.509 client verification.  Note
that this is based on puppet's PKI.

## Setup

### Setup Requirements

The following modules are required:

* http://github.com/puppetlabs/puppetlabs-apache
* http://github.com/puppetlabs/puppetlabs-stdlib
* http://github.com/puppetlabs/puppetlabs-vcsrepo

## Usage

A basic stand alone nfsen with web gui is acheived via

```puppet
include ::nfsen
```

However there are a few tweaks required to other modules to get a working setup
via hiera

```yaml
apache::default_vhost: false
apache::mpm_module: 'prefork'
```

## Limitations

* Only tested on Ubuntu Trusty 14.04
