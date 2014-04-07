#!/usr/bin/env ruby
# encoding: utf-8

# File: catalog_table.rb
# Created:  24/09/13
#
# (c) Michel Demazure <michel@demazure.com>

# Script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Table widget for showing the Gescom input state of affairs
    class CatalogTable < Table
      # List of parameters of importers : [directory, source file, call_name]
      PARAMETER_LIST =
          [
              %w(Articles Articles.slk ca),
              %w(Nomenclatures Nomenclatures.slk cn),
              %w(Stock Stock.txt cs),
              %w(Tarifs Tarifs.csv ct)
          ]
      # list of importers
      CATALOG_IMPORTER_LIST = PARAMETER_LIST.map do |sub_dir, filename, cmd|
        path = File.join('Catalogue', sub_dir, filename)
        AspawayUpdater.new(path, cmd)
      end
      # first line
      HEADERS = PARAMETER_LIST.map(&:first) + ['Utiliser le catalogue']
      # limit in days
      GREEN_YELLOW = 15
      # limit in days
      YELLOW_RED = 30

      # WARNING: do not refactorize with 'map' and 'any?'
      # update the catalog database when sage files are refreshed
      def self.update_catalog_if_needed
        needed = false
        CATALOG_IMPORTER_LIST.each do |importer|
          if importer.need_update
            importer.update
            needed = true
          end
        end
        Command.ce.cron_execute if needed
      end

      # Build a new instance
      def initialize
        super(3, 6)
        build_first_line(HEADERS)
        build_first_column(['Exporté de Gescom', 'Pour exporter'])
        horizontalHeader.setResizeMode(Qt::HeaderView::Stretch)
        set_item(0, 0, TableItem.new('Exportations'))
        build_values
        build_help_items
      end

      # Build/refresh the table values
      #   and export the catalog csv file if needed
      def build_values
        CatalogTable.update_catalog_if_needed
        build_age_items
      end

      # build the age items
      def build_age_items
        CATALOG_IMPORTER_LIST.each_with_index do |importer, indx|
          set_age_item(indx + 1, importer.source_age)
        end
      end

      # Build the help items
      def build_help_items
        (PARAMETER_LIST.size + 1).times do |index|
          set_item(2, index + 1, TableItem.new('Voir l\'aide'))
        end
      end

      # Build the item in this col, colored w.r.t. given age
      #   Item color is given by comparing to limit values
      #
      # @param [Integer] col column number
      # @param [Numeric,nil] age age in hours
      def set_age_item(col, age)
        days = age ? (age / 24).round : YELLOW_RED
        text = TableItem.text_for_age(age)
        color = TableItem.color_for_value(days, GREEN_YELLOW, YELLOW_RED)
        set_item(1, col, TableItem.new(text, color))
      end

      # Slot: when clicked, show help file
      # @param [Integer] row row number
      # @param [Integer] col column number
      def clicked(row, col)
        return unless row == 2 && col > 0
        title, filename = CatalogTable.help_parameters_for(col)
        file = File.join(File.dirname(__FILE__), 'gescom_help_files', filename)
        show_file(title, file)
      end

      # Give parameters for the help MessageBox
      # @param [Integer] col column number
      # @return [[String, Path]] title, help file to show
      def self.help_parameters_for(col)
        case col
        when 5
          ['Comment utiliser le catalogue', 'help_catalogue.txt']
        else
          name = PARAMETER_LIST[col - 1].first
          ["Comment exporter '#{name}'", "help_#{name}.txt"]
        end
      end
    end
  end
end
