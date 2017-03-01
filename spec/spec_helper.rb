require 'rubygems'
require 'puppetlabs_spec_helper/module_spec_helper'
if Gem.loaded_specs['rspec'].version < Gem::Version.create('3.2.0')
  require 'coverage_patch'
end

base_dir = File.dirname(File.expand_path(__FILE__))

RSpec.configure do |c|
  c.module_path     = File.join(base_dir, 'fixtures', 'modules')
  c.manifest_dir    = File.join(base_dir, 'fixtures', 'manifests')
  c.manifest        = File.join(base_dir, 'fixtures', 'manifests', 'site.pp')
  c.environmentpath = File.join(Dir.pwd, 'spec')
end
