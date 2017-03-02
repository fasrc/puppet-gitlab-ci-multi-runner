require 'rake'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'
require 'puppet-syntax/tasks/puppet-syntax'
PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.send('disable_autoloader_layout')
PuppetLint.configuration.ignore_paths = ["spec/**/*.pp", "pkg/**/*.pp"]

PuppetSyntax.exclude_paths = ['tests', 'specs']

namespace :syntax do
  desc "Syntax check Ruby files"
  task :rubylibs do
    puts '---> syntax:rubylibs'
    Dir['lib/**/*.rb'].each do |ruby_file|
      sh "ruby -c #{ruby_file}" unless ruby_file =~ /spec\/fixtures/
    end
  end
end

Rake::Task['syntax'].enhance do
  Rake::Task['syntax:rubylibs'].invoke
end

task :test => [
  :lint,
  :syntax,
  :spec
]
