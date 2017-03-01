source 'https://rubygems.org'

puppetversion = ENV.key?('PUPPET_GEM_VERSION') ? "= #{ENV['PUPPET_GEM_VERSION']}" : ['>= 3.3']
rspecversion = ENV.key?('RSPEC_GEM_VERSION') ? "= #{ENV['RSPEC_GEM_VERSION']}" : ['>=3.2.0']
gem 'puppet', puppetversion
gem 'rspec', rspecversion
gem 'puppetlabs_spec_helper', '>= 0.1.0'
gem 'puppet-lint', '>= 0.3.2'
gem 'puppet-syntax', '>=2.2.0'
gem 'facter', '>= 1.7.0'

