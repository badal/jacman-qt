#!/usr/bin/env ruby
# encoding: utf-8

# File: catalog_manager_qt.rb
# Created: 2/10/13/13
#
# (c) Michel Demazure <michel@demazure.com>

require 'jacman/core'

require_relative('version.rb')
require_relative('elements/log.rb')
require_relative('elements/manager_main.rb')
require_relative('elements/catalog_manager_elements.rb')
require_relative('elements/catalog_central_widget.rb')

JacintheManagement.open_log
JacintheManagement.log('Opening catalog manager')
central_class = JacintheManagement::GuiQt::CatalogCentralWidget
JacintheManagement::GuiQt::ManagerMain.run(central_class)
JacintheManagement.log('Closing catalog manager')
