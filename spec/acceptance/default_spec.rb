require 'spec_helper_acceptance'

describe 'nfsen' do
  context 'default server' do

    it 'provisions with no errors' do
      # Create a CA and certificate for the web server
      shell('puppet cert generate $(facter fqdn)')
      # Add in an MPM module for mod_php
      shell('echo "apache::mpm_module: \'prefork\'" >> /var/lib/hiera/common.yaml')
      # Disable the default vhost
      shell('echo "apache::default_vhost: false" >> /var/lib/hiera/common.yaml')

      pp = <<-EOS
        Exec {
          path => '/bin:/usr/bin:/sbin:/usr/sbin',
        }

        include ::nfsen
      EOS

      # Check for clean provisioning and idempotency
      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    it 'listens on port 443' do
      shell('netstat -l | grep https', :acceptable_exit_codes => 0)
    end

    it 'returns a HTTP 200 status code' do
      shell('curl -I https://localhost/nfsen/ -k | grep "HTTP/1.1 200 OK"', :acceptable_exit_codes => 0)
    end

  end
end
