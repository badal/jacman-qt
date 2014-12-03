#!/usr/bin/env ruby
# encoding: utf-8

# File: pending_table.rb
# Created:  24/09/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  # all classes and methods for both GUIs
  module GuiQt
    # suspending user events for at most 20 seconds
    # @yieldparam [Block] block to be executed during the suspension
    def self.suspending_user_events
      Qt::CoreApplication.processEvents(1, 20_000)
      yield
      Qt::CoreApplication.process_events
    end

    WAITING_TEXT =
        [
            'Importation des Ventes en cours',
            'ATTENDRE',
            'Ne pas fermer la fenêtre'
        ].join("\n")

    # showing a message box while a task is processed
    # @param [Qt::Widget] parent parent widget
    # @yieldparam [Block] block to be executed while box is shown
    def self.under_warning(parent)
      msg = Qt::MessageBox.new(parent)
      #  msg.set_window_flags(msg.window_flags & ~Qt::WindowCloseButtonHint)
      #  msg.set_modal(false)
      msg.set_window_title('IMPORTATION EN COURS')
      msg.set_text(WAITING_TEXT)
      msg.show
      yield
      msg.close
    end

    # Table widget for showing pendant actions
    class PendingTable < Table
      # First column
      SUBTITLES =
          [
              'Opérations',
              'Etat',
              'Actions'
          ]
      # Headers for the table
      HEADERS =
          [
              'Fichier ventes GESCOM',
              'Ventes non importées',
              'Fichiers clients non lus',
              'Clients à exporter'
          ]

      # whether column may have button
      BUTTONS = [false, true, true, false, false]

      # Actions corresponding to the second row
      ACTION_FOR =
          [
              nil, # -> { gi! },
              -> { Core::Sales.show_remaining_sales },
              -> { Core::Clients.show_client_files },
              nil,
          ]

      # Build a new instance
      def initialize
        super(3, 5)
        @count = 0
        SUBTITLES.each_with_index do |subtitle, indx|
          set_item(indx, 0, TableItem.new(subtitle))
        end
        HEADERS.each_with_index do |title, indx|
          set_item(0, indx + 1, TableItem.new(title))
        end
        @importer = AspawayUpdater.new('DocVente/Ventes.slk', 'gi')
        build_values
      end

      # Build the values and buttons items
      def build_values
        refresh_values
        process_sales_if_needed if JacintheManagement::REAL
        build_sales_file_watcher
        [0, 2].each do |indx|
          build_column(indx + 2, @values[indx], BUTTONS[indx + 1])
        end
        build_column(3, @values[1], true, 2)
      end

      # fetch values and refresh the variables
      def refresh_values
        @values = Core::Info.refresh_values
      end

      # @return [Boolean] whether new clients exist
      def clients?
        @values[3] > 0
      end

      # Build the first item (sales)
      def build_sales_file_watcher
        age = @importer.source_age
        text = TableItem.text_for_age(age)
        color = TableItem.color_for_value(age, 24, 168)
        set_item(1, 1, TableItem.new(text, color))
       # set_item(2, 1, TableItem.new('Importer', '#F00')) if @importer.need_update
      end

      # Import the sales if  file is newer
      def process_sales_if_needed
        return unless @importer.need_update
        GuiQt.suspending_user_events do
          GuiQt.under_warning(self) { @importer.update }
        end
      end

      # Build both items in this column
      # @param [Integer] col column index
      # @param [Integer] value to be shown in item
      # @param [Integer] limit limit value for red
      # @param [Boolean] button whether the second case is to be active
      def build_column(col, value, button, limit = 999_999)
        color = TableItem.color_for_value(value.to_i, 1, limit)
        set_item(1, col, TableItem.new(value.to_s, color))
        set_item(2, col, TableItem.new('Voir le fichier', '#EEE')) if value.to_s != '0' && button
      end

      # Slot : show the corresponding directory/file when the item is clicked
      # @param [Integer] row row index
      # @param [Integer] col column index
      def clicked(row, col)
        return unless row == 2 && BUTTONS[col -1] && @values[col - 1].to_s != '0'
        ACTION_FOR[col - 1].call
      end

      # # force gi command
      # def gi!
      #
      #   puts "go"
      #   GuiQt.suspending_user_events do
      #     GuiQt.under_warning(self) { Core::Command.cron_run('gi') }
      #   end
      # end

    end
  end
end
