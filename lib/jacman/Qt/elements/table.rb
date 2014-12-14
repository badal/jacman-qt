#!/usr/bin/env ruby
# encoding: utf-8

# File: table.rb
# Created:  24/09/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Colored items for the Table widget
    class TableItem < Qt::TableWidgetItem
      # @param [String] text text of item
      # @param [String] color hex description of color
      # @return [TableItem] new instance
      def initialize(text, color = '#FFF')
        super(text)
        brush = Qt::Brush.new(Qt::Color.new(color), Qt::SolidPattern)
        set_background(brush)
      end

      # Fix the color corresponding to the given value
      # @param [Numeric] value value to compare
      # @param [Numeric] green_yellow limit value (<)
      # @param [Numeric] yellow_red limit value (<)
      # @return [Constant] name of color
      def self.color_for_value(value, green_yellow, yellow_red)
        if value && value < green_yellow
          GREEN
        elsif value && value < yellow_red
          YELLOW
        else
          RED
        end
      end

      # @return [Numeric] age in text
      # @param [Numeric|nil] age in number (hours)
      def self.text_for_age(age)
        return 'jamais' unless age
        age = age.to_i
        case age
        when 0...24
          "il y a #{age} heure(s)"
        when 24...168
          "il y a #{age / 24} jour(s)"
        when 168...720
          "il y a #{age / 168} semaine(s)"
        else
          "il y a #{age / 720} mois"
        end
      end
    end

    # Table widget for Manager
    #   without outside headers
    class Table < Qt::TableWidget
      slots 'clicked(int, int)'

      # Color table for delay categories
      COLOR_TABLE = { OK: GREEN, LATE: YELLOW, ERROR: RED, NEVER: YELLOW }

      # Build a new instance
      # @param [Integer] rows number of rows
      # @param [Integer] cols number of columns
      def initialize(rows, cols)
        super(rows, cols)
        horizontalHeader.setResizeMode(Qt::HeaderView::Stretch)
        horizontalHeader.setVisible(false)
        verticalHeader.setVisible(false)
        connect(self, SIGNAL('cellClicked(int, int)'), self, SLOT('clicked(int, int)'))
      end

      # Build the horizontal headers
      # @param [Array<String>] headers horizontal headers
      def build_first_line(headers)
        headers.each_with_index do |hdr, indx|
          set_item(0, indx + 1, TableItem.new(hdr))
        end
      end

      # Build the vertical headers
      # @param [Array<String>] headers vertical headers
      def build_first_column(headers)
        headers.each_with_index do |hdr, indx|
          set_item(indx + 1, 0, TableItem.new(hdr))
        end
      end

      # Abstract slot, to be overridden
      # def clicked(row, col) end
    end
  end
end
