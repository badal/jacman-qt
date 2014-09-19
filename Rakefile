require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'

require_relative 'lib/jacman/qt/version.rb'

desc 'build gem file'
task :build_gem do
  system 'gem build jacman-qt.gemspec'
  FileUtils.cp(Dir.glob('*.gem'), ENV['LOCAL_GEMS'])
end

desc "build Manifest"
task :manifest do
  system ' mast lib bin spec HISTORY.md LICENSE Rakefile README.md > MANIFEST '
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "Jacinthe Management #{JacintheManagement::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
  t.options += ['--files', 'HISTORY.md']
  t.options += ['--files', 'MANIFEST']
  t.options += ['--no-private']
end

desc "yard undocumented"
task :undoc do
  system 'yard stats --list-undoc'
end

Rake::TestTask.new do |t|
  t.libs.push 'lib'
  t.test_files = FileList['spec/*_spec.rb']
  t.verbose = true
end

import('metrics.rake') if File.exist?('metrics.rake')
