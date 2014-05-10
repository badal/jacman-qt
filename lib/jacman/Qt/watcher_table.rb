#!/usr/bin/env ruby
# encoding: utf-8

# File: watcher_table.rb
# Created:  24/09/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Table to show reports of cronman activities
    class WatcherTable < Table
      # Build the reporting text for this age and level
      # @param [Symbol] level severity symbol
      # @param [Numeric] age age in hours
      # @return [String] reporting text
      def self.checking_text(level, age)
        case level
        when :OK, :LATE
          "Exécutée #{TableItem.text_for_age(age)}"
        when :ERROR
          'Erreur à l\'exécution'
        else # when :NEVER
          'Jamais exécutée'
        end
      end

      # @param [Array<String>] list list of cronman commands to watch
      # @return [WatcherTable] a new instance
      def initialize(list)
        super(3, list.size + 1)
        @list = list
        @headers = @list.map { |call_name| Core::Command.send(call_name).title }
        build_first_line(@headers)
        build_first_column(['Résultat de l\'exécution', 'Rapport'])
        build_values
      end

      # Build the items in the table
      def build_values
        @elements = Core::CommandWatcher.report(@list)
        @elements.each_with_index do |(level, _, age), col|
          build_column_for(col + 1, age, level)
        end
      end

      # Build a column
      # @param [Integer] col column number
      # @param [Object] age age in hours
      # @param [Object] level severity
      def build_column_for(col, age, level)
        top = WatcherTable.checking_text(level, age)
        bottom = button(level)
        color = COLOR_TABLE[level]
        set_item(1, col, TableItem.new(top, color))
        set_item(2, col, TableItem.new(bottom))
      end

      # Build the text for the bottom entry
      # @param [Symbol] level severity symbol
      # @return [String] text for button
      def button(level)
        case level
        when :OK, :LATE
          'Voir le rapport'
        when :ERROR
          'Voir le rapport d\'erreur'
        else
          ''
        end
      end

      # Slot: when clicked, show the corresponding help file
      # @param [Integer] row row number
      # @param [Integer] col column number
      def clicked(row, col)
        return unless row == 2
        level, file, _ = @elements[col - 1]
        title = @headers[col - 1]
        show_file(title, file) unless level == :NEVER
      end
    end
  end
end
