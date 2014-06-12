#!/usr/bin/env ruby
# encoding: utf-8
#
# File: version.rb
# Created: 28 June 2013
#
# (c) Michel Demazure & Kenji Lefevre

module JacintheManagement
  MAJOR = 2
  MINOR = 1
  TINY = 0

  VERSION = [MAJOR, MINOR, TINY].join('.').freeze

  COPYRIGHT = "\u00A9 Michel Demazure"

end

if __FILE__ == $PROGRAM_NAME

  puts JacintheManagement::VERSION

end
