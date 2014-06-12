require 'rubygems/package_task'
require 'yard'
require 'yard/rake/yardoc_task'
require 'rake/testtask'

require_relative 'lib/jacman/qt/version.rb'

spec = Gem::Specification.new do |s|
  s.name = 'jacman-qt'
  s.version = JacintheManagement::VERSION
  s.has_rdoc = true
  s.extra_rdoc_files = %w(README.md LICENSE)
  s.summary = 'Script tools for Jacinthe DB management'
  s.description = 'Script tools for Jacinthe DB management'
  s.author = 'Michel Demazure'
  s.email = 'michel@demazure.com'
  s.add_dependency 'qtbindings'
  s.add_dependency 'jacman-core'
  s.homepage = 'http://github.com/badal/jacman-qt'
  s.license = 'MIT'
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('{bin,lib,spec}/**/*')
  s.executables = %w(manager catalog_manager)
  s.require_path = 'lib'
  s.bindir = 'bin'
end

Gem::PackageTask.new(spec) do |p|
  p.package_dir = ENV['LOCAL_GEMS']
  p.gem_spec = spec
  p.need_tar = false
  # p.need_zip = true
end

desc "build Manifest"
task :manifest do
  system ' mast lib bin spec HISTORY.md LICENSE Rakefile README.md > MANIFEST '
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
