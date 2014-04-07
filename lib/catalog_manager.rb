#!/usr/bin/env ruby
# encoding: utf-8

# File: catalog_manager.rb
# Created: 2/10/13/13
#
# (c) Michel Demazure <michel@demazure.com>

require_relative('jacman/require_core.rb')

require_relative('jacman/Qt/log.rb')
require_relative('jacman/Qt/manager_main.rb')
require_relative('jacman/Qt/catalog_manager_qt.rb')
require_relative('jacman/Qt/catalog_central_widget.rb')

JacintheManagement.open_log
JacintheManagement.log('Opening catalog manager')
central_class = JacintheManagement::GuiQt::CatalogCentralWidget
JacintheManagement::GuiQt::ManagerMain.run(central_class)
JacintheManagement.log('Closing catalog manager')
