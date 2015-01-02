#!/usr/bin/env ruby
# encoding: utf-8

# File: common_main.rb
# Created: 18/08/13
#
# (c) Michel Demazure <michel@demazure.com>

require 'Qt'

module JacintheManagement
  module GuiQt
    # @param [String] message to be shown
    # @return [Bool] answer to dialog
    def self.confirm_dialog(message)
      message_box = Qt::MessageBox.new(Qt::MessageBox::Warning, 'Jacinthe', message)
      message_box.setWindowIcon(Icons.from_file('Board-11-Flowers-icon.png'))
      message_box.setInformativeText('Confirmez-vous ?')
      message_box.addButton('OUI', Qt::MessageBox::AcceptRole)
      no_button = message_box.addButton('NON', Qt::MessageBox::RejectRole)
      message_box.setDefaultButton(no_button)
      message_box.exec == 0
    end

    # Common main window
    class CommonMain < Qt::MainWindow
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
            "#{central_widget.subtitle}"
        @central_widget = central_widget
        @status = build_status_bar
        self.central_widget = @central_widget
        set_geometry(*central_widget.geometry) if central_widget.geometry
        update_values
      end

      # Build the status bar
      # @return [Qt::StatusBar] the completed and connected status bar
      def build_status_bar
        status = statusBar
        about = Qt::PushButton.new('A propos...')
        help = Qt::PushButton.new(Icons.icon('standardbutton-help'), 'Aide')
        @central_widget.extend_status(status)
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
        text = @central_widget.about.join("\n")
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
