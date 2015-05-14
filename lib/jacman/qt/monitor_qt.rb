#!/usr/bin/env ruby
# encoding: utf-8

# File: monitor_qt.rb
# Created: 17/08/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative('version.rb')
require_relative('base.rb')
require_relative('elements/monitor_help.rb')
require_relative 'elements/monitor_elements.rb'
require_relative('elements/monitor_central_widget.rb')

module JacintheManagement
  # put REAL=false  to avoid automatic processing of sales
  REAL = true
end

JacintheManagement.open_log('monitor.log')
JacintheManagement.log('Opening monitor')
JacintheManagement::Core::Infos.report.each do |info|
  JacintheManagement.log(info)
end
central_class = JacintheManagement::GuiQt::MonitorCentralWidget
JacintheManagement::GuiQt::CommonMain.run(central_class)
JacintheManagement::Core::Infos.report.each do |info|
  JacintheManagement.log(info)
end
JacintheManagement.log('Closing monitor')
