#!/usr/bin/env ruby
# encoding: utf-8

# File: central_widget.rb
# Created:  18/08/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Common central widget for all managers
    class CentralWidget < Qt::Widget
      # @return [CentralWidget] new instance
      def initialize
        super()
        @frames = []
        @layout = Qt::VBoxLayout.new(self)
        build_layout
      end

      # abstract method
      # @return [String] name of manager specialty
      def subtitle
        'to be overridden'
      end

      # @return [Array<String>] about_message
      def about
        [subtitle,
         'Versions',
         "   jacman-qt : #{JacintheManagement::VERSION}",
         "   jacman-utils : #{JacintheManagement::Utils::VERSION}",
         "   jacman-core : #{JacintheManagement::Core::VERSION}",
         'S.M.F. 2011-2014',
         "#{JacintheManagement::COPYRIGHT}", 'LICENCE M.I.T.'
        ]
      end

      # Add a horizontal line
      def add_line
        @layout.add_widget(HLine.new)
      end

      # Add a widget
      # @param [Qt::Widget] widget widget to be added to layout
      def add_widget(widget)
        @layout.add_widget(widget)
      end

      # Add a layout
      # @param [Qt::Layout] layout layout to be added to layout
      def add_layout(layout)
        @layout.add_layout(layout)
      end

      # Add a subtitle label
      # @param [String] title label of the line
      def add_line_header(title)
        @layout.add_spacing(5)
        # noinspection RubyArgCount
        label = Qt::Label.new("<b>#{title.upcase}</b>")
        label.indent = 50
        @layout.add_widget(label)
        @layout.add_spacing(5)
      end

      # Add a subtitle label with a help button
      # @param [String] title label of the line
      # @param [Symbol] help_command slot to call by button
      def add_line_header_with_help(title, help_command)
        horiz = Qt::HBoxLayout.new
        # noinspection RubyArgCount
        label = Qt::Label.new("<b>#{title.upcase}</b>")
        label.indent = 50
        horiz.add_widget(label)
        # noinspection RubyArgCount
        help_button = Qt::PushButton.new(Icons.icon('standardbutton-help'), 'Aide')
        self.class.slots help_command
        connect(help_button, SIGNAL(:clicked), self, SLOT(help_command))
        horiz.add_stretch
        horiz.add_widget(help_button)
        @layout.add_layout(horiz)
      end

      # to be overridden in subclasses
      def extend_status(_status)
      end

      # Refresh by sending 'build_values' to all TableWidget children
      def update_values
        @layout.count.times do |indx|
          widget = @layout.item_at(indx).widget
          widget.build_values if widget && widget.is_a?(Qt::TableWidget)
        end
      end
    end
  end
end
