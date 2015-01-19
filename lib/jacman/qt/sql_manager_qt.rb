#!/usr/bin/env ruby
# encoding: utf-8

# File: notifier_qt.rb
# Created: 13/12/14
#
# (c) Michel Demazure <michel@demazure.com>

require_relative('version.rb')
require_relative('elements/log.rb')
require_relative('elements/icons.rb')
require_relative 'elements/sqlfiles.rb'
require_relative('elements/common_main.rb')
require_relative('elements/central_widget.rb')
require_relative('elements/sql_manager_central_widget.rb')

JacintheManagement.open_log('sql_manager.log')
JacintheManagement.log('Opening SQL manager')
central_class = JacintheManagement::GuiQt::SqlManagerCentralWidget
JacintheManagement::GuiQt::CommonMain.run(central_class)
JacintheManagement.log('Closing SQL manager')
