require 'rubygems'
require 'puppetlabs_spec_helper/rake_tasks'
require 'puppet-lint/tasks/puppet-lint'

PuppetLint.configuration.send('disable_80chars')
PuppetLint.configuration.ignore_paths = ['spec/**/*.pp', 'pkg/**/*.pp']

desc 'Markdown lint checking'
namespace :validate do
  desc 'Run all validators'
  task :all => [:puppet, :ruby, :erb, :markdown]

	desc 'Validate Puppet files'
	task :puppet do
		 Dir['manifests/**/*.pp'].each do |manifest|
			sh "puppet parser validate --noop #{manifest}"
		end
	end

	desc 'Validate Ruby files'
	task :ruby do
	  Dir['spec/**/*.rb', 'lib/**/*.rb'].each do |ruby_file|
	    sh "ruby -c #{ruby_file}" unless ruby_file =~ %r{spec\/fixtures}
	  end
	end

  desc 'Validate ERB Files'
  task :erb do
    Dir['templates/**/*.erb'].each do |template|
      sh "erb -P -x -T '-' #{template} | ruby -c"
    end
  end

  desc 'Validate Markdown files'
  task :markdown do
    Dir['**/*.md'].each do |template|
      sh "mdl -c .mdlrc #{template}"
    end
  end
end
