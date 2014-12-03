#!/usr/bin/env ruby
# encoding: utf-8

# File: manager_qt.rb
# Created: 17/08/13
#
# (c) Michel Demazure <michel@demazure.com>
require 'jacman/core'

require 'j2r/jaccess'
require 'j2r/core'

require_relative('version.rb')
require_relative('elements/manager_help.rb')
require_relative('elements/log.rb')
require_relative('elements/manager_main.rb')
require_relative 'elements/manager_elements.rb'
require_relative('elements/manager_central_widget.rb')

module JacintheManagement
  REAL = true
end

JacintheManagement.open_log
JacintheManagement.log('Opening manager')
central_class = JacintheManagement::GuiQt::ManagerCentralWidget
JacintheManagement::GuiQt::ManagerMain.run(central_class)
JacintheManagement.log('Closing manager')


