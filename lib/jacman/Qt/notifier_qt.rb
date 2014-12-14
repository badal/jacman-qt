#!/usr/bin/env ruby
# encoding: utf-8

# File: notifier_qt.rb
# Created: 13/12/14
#
# (c) Michel Demazure <michel@demazure.com>
require 'jacman/core'
require 'jacman/notifications'

require_relative('version.rb')
# require_relative('elements/monitor_help.rb')
require_relative('elements/log.rb')
require_relative('elements/notifier_main.rb')
require_relative 'elements/monitor_elements.rb'
require_relative('elements/notifier_central_widget.rb')

JacintheManagement.open_log
JacintheManagement.log('Opening notifier')
central_class = JacintheManagement::GuiQt::NotifierCentralWidget
JacintheManagement::GuiQt::NotifierMain.run(central_class)
JacintheManagement.log('Closing notifier')
