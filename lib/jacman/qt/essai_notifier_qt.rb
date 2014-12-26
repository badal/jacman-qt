#!/usr/bin/env ruby
# encoding: utf-8

# File: notifier_qt.rb
# Created: 13/12/14
#
# (c) Michel Demazure <michel@demazure.com>
require_relative '../../../../jacman-utils/lib/jacman/utils.rb'
require_relative '../../../../jacman-core/lib/jacman/core.rb'
require_relative '../../../../jacman-notifications/lib/jacman/notifications.rb'
# require 'jacman/notifications'

require_relative('version.rb')
# require_relative('elements/monitor_help.rb')
require_relative('elements/log.rb')
require_relative('elements/icons.rb')
require_relative('elements/common_main.rb')
require_relative('elements/central_widget.rb')
require_relative('elements/notifier_central_widget.rb')

JacintheManagement.open_log('notifier.log')
JacintheManagement.log('Opening notifier')
central_class = JacintheManagement::GuiQt::NotifierCentralWidget
JacintheManagement::GuiQt::CommonMain.run(central_class)
JacintheManagement.log('Closing notifier')
