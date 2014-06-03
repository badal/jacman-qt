#!/usr/bin/env ruby
# encoding: utf-8

# File: qt_manager.rb
# Created: 17/08/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative('jacman/require_core.rb')

require_relative('jacman/Qt/manager_help.rb')
require_relative('jacman/Qt/log.rb')
require_relative('jacman/Qt/manager_main.rb')
require_relative 'jacman/Qt/manager_elements.rb'
require_relative('jacman/Qt/manager_central_widget.rb')

JacintheManagement.open_log
JacintheManagement.log('Opening manager')
central_class = JacintheManagement::GuiQt::ManagerCentralWidget
JacintheManagement::GuiQt::ManagerMain.run(central_class)
JacintheManagement.log('Closing manager')
