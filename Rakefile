require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'

require_relative 'lib/jacman/version.rb'

spec = Gem::Specification.new do |s|
  s.name = 'jacman'
  s.version = JacintheManagement::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'Script tools for Jacinthe DB management'
  s.description = 'Script tools for Jacinthe DB management'
  s.author = 'Michel Demazure, Kenji Lefevre'
  s.email = 'michel@demazure.com'
  s.executables = %w(batman.sh catalog_manager.sh cronman.sh jacdev.sh manager.sh)
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{bin,lib,spec}/**/*')
  s.require_path = 'lib'
  s.bindir = 'bin'
end

Gem::PackageTask.new(spec) do |p|
  p.gem_spec = spec
  p.need_tar = true
  # p.need_zip = true
end

desc "build Manifest"
task :manifest do
  system ' mast lib spec HISTORY.md LICENSE Rakefile README.rb > MANIFEST '
end

YARD::Rake::YardocTask.new do |t|
  t.options += ['--title', "Jacinthe Management #{JacintheManagement::VERSION} Documentation"]
  t.options += %w(--files LICENSE)
  t.options += ['--files', 'HISTORY.md']
  t.options += ['--files', 'TODO.md']
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
