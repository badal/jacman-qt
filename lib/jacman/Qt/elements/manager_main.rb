#!/usr/bin/env ruby
# encoding: utf-8

# File: manager_main.rb
# Created: 18/08/13
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'

module JacintheManagement
  module GuiQt
    # Manager main window
    class ManagerMain < Qt::MainWindow
      # "About" message
      ABOUT = ["Version #{JacintheManagement::VERSION}", 'S.M.F. 2011-2013',
               "#{JacintheManagement::COPYRIGHT}", 'LICENCE M.I.T.']

      slots :about, :help, :update_values

      # tests whether window is active or minimized
      # @param [Qt::Object] obj origin of event
      # @param [Qt::Event] event event sent
      # noinspection RubyInstanceMethodNamingConvention
      def eventFilter(obj, event) # rubocop:disable MethodName
        @active = windowState == 0 if event.type == Qt::Event::WindowStateChange
        super(obj, event)
      end

      # A new instance
      def initialize(central_widget)
        super()
        install_event_filter(self)
        @active = true
        self.window_icon = Icons.from_file('Board-11-Flowers-icon.png')
        self.window_title =
            "#{central_widget.subtitle}, version #{JacintheManagement::VERSION}"
        @status = build_status_bar
        @central_widget = central_widget
        self.central_widget = @central_widget
        set_geometry(*central_widget.geometry)
        update_values
      end

      # Build the status bar
      # @return [Qt::StatusBar] the completed and connected status bar
      def build_status_bar
        status = statusBar
        about = Qt::PushButton.new('A propos...')
        help = Qt::PushButton.new(Icons.icon('standardbutton-help'), 'Aide')
        status.addPermanentWidget(help)
        status.addPermanentWidget(about)
        status.connect(about, SIGNAL(:clicked), self, SLOT(:about))
        status.connect(help, SIGNAL(:clicked), self, SLOT(:help))
        status
      end

      # Start the application
      def self.run(central_widget_class)
        application = Qt::Application.new(ARGV)
        central_widget = central_widget_class.new
        new(central_widget).show
        application.exec
      rescue => error
        JacintheManagement.err(error)
      end

      # Slot : open the about dialog
      def about
        text = ([@central_widget.subtitle] + ABOUT).join("\n")
        Qt::MessageBox.about(self, 'Jacinthe Management', text)
      end

      # Slot: open the help dialog
      def help
        @central_widget.help
      end

      # Slot: update the clock and refresh the central widget
      def update_values
        if @active
          @status.showMessage Time.now.strftime('%F   %T')
          @central_widget.update_values
        end
        Qt::Timer.singleShot(1000, self, SLOT(:update_values))
      end
    end
  end
end
