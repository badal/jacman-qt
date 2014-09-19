# encoding: utf-8

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift(dir) unless $LOAD_PATH.include?(dir)

require 'lib/jacman/qt/version.rb'

Gem::Specification.new do |s|
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
  s.files = %w(LICENSE README.md HISTORY.md MANIFEST Rakefile) + Dir.glob('lib,spec}/**/*')
  s.require_path = 'lib'
end

