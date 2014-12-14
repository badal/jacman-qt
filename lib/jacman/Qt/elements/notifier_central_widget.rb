#!/usr/bin/env ruby
# encoding: utf-8

# File: monitor_central_widget.rb
# Created:  02/10/13 for manager
# Modified: 12/14 for monitor
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Central widget for manager
    class NotifierCentralWidget < CentralWidget

        # @return [[Integer] * 4] geometry of mother window
      def geometry
        if Utils.on_mac?
          [0, 100, 1200, 900]
        else
          [0, 100, 900, 620]
        end
      end

      # @return [String] name of manager specialty
      def subtitle
        'Notification des abonnement électroniques, prototype'
      end

      def build_layout

      end

      def update_values
        # super
      end

    end
  end
end
__END__
      # FIXME: notifier help
     # include MonitorHelp

      slots :report

      # Night commands to watch
      AUTO_COMMANDS = %w(di de ep ea jtd)

      # Core::Command frames to build
      COMMANDS = %w(de di ge ep ea)

      # Build the layout
      def build_layout
        add_line_header_with_help('Operations automatiques : compte-rendu', :help_night)
        add_widget(WatcherTable.new(AUTO_COMMANDS))
        add_line

        add_line_header_with_help('Liaison avec gescom : surveillance', :help_pending)
        @pending_table = PendingTable.new
        add_widget(@pending_table)
        add_line

        add_line_header_with_help('Operations de gestion : commandes', :help_cmd)
        add_horizontal_range(COMMANDS)
        add_report_area
        add_line
      end


      # Add a command range
      # @param [Array<String>] cmds call names of commands for this range
      def add_horizontal_range(cmds)
        widgets = cmds.map { |cmd| cmd ? command_widget(cmd) : EmptyFrame.new }
        Qt::HBoxLayout.new.tap do |horiz|
          widgets.each { |widget| horiz.add_widget(widget) }
          add_layout(horiz)
        end
      end

      # create and connect the command widget for this command
      # @param [String] cmd call_name of command
      # @return [CommandFrame] command widget
      def command_widget(cmd)
        frame = CommandFrame.with(cmd)
        @frames << frame
        connect(frame, SIGNAL(:output_written), self, SLOT(:report))
        frame
      end

      # Build the bottom area
      def add_report_area
        @layout.add_stretch
        @report = Qt::TextEdit.new
        @report.set_minimum_size(500, 150)
        add_widget(@report)
      end

      # Slot: show in the report area
      #   the text received by the command frames.
      #   Logging added here for debugging
      def report
        res = @frames.map(&:received)
        text = res.select { |line| line && line != "\n" }.first
        return unless text
        # WARNING: here logging
        JacintheManagement.log(text)
        @report.append(text)
        Qt::CoreApplication.process_events
      end

      # enabling/disabling buttons
      def update_values
        super
        @frames[2].enabled = @pending_table.clients?
        #     @frames[5].enabled = @pending_table.notifications?
      end
    end
  end
end