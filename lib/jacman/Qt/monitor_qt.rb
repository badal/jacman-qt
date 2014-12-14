#!/usr/bin/env ruby
# encoding: utf-8

# File: monitor_qt.rb
# Created: 17/08/13
#
# (c) Michel Demazure <michel@demazure.com>
require 'jacman/core'

require_relative('version.rb')
require_relative('elements/monitor_help.rb')
require_relative('elements/log.rb')
require_relative('elements/manager_main.rb')
require_relative 'elements/monitor_elements.rb'
require_relative('elements/monitor_central_widget.rb')

module JacintheManagement
  REAL = true
end

JacintheManagement.open_log
JacintheManagement.log('Opening monitor')
central_class = JacintheManagement::GuiQt::MonitorCentralWidget
JacintheManagement::GuiQt::ManagerMain.run(central_class)
JacintheManagement.log('Closing monitor')
