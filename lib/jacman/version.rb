#!/usr/bin/env ruby
# encoding: utf-8
#
# File: version.rb
# Created: 28 June 2013
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  MAJOR = 1
  MINOR = 9
  TINY = 2

  VERSION = [MAJOR, MINOR, TINY].join('.').freeze
end

if __FILE__ == $PROGRAM_NAME

  puts JacintheManagement::VERSION

end
