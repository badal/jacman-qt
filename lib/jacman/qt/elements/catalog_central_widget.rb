#!/usr/bin/env ruby
# encoding: utf-8

# File: catalog_central_widget.rb
# Created:  02/10/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Central widget for manager
    class CatalogCentralWidget < CentralWidget
      CATALOG_HELP = <<END_CATALOG_HELP
Une base de données nommée catalogue permet d'afficher plus aisément les prix
et les articles de Sage. Cette base ne sert pas à gérer les prix et les stocks.
Elle sert uniquement à pouvoir accéder à ces données sous la forme d'un fichier
OpenOffice Calc ou via le language SQL.

Les données contenues dans cette base ne se mettent pas à jour automatiquement.
Il faut donc alimenter cette base régulièrement afin que ses données soient
synchrones avec celles de Sage Gescom.

Pour ce faire, on doit mettre à jour séparément les quatre éléments :
articles, nomenclature, tarifs et stocks.
Chacune des ces exportations se trouve expliquée dans l'aide correspondante.

Chacune des quatre exportations de Gescom déclenche automatiquement
l'importation correspondante et la mise à jour du catalogue.

Pour l'utilisation dudit catalogue, on se réferera à l'aide spécifique.
END_CATALOG_HELP

      # Gescom commands to watch
      CATALOG_COMMANDS = %w(ca cn cs ct ce)

      # Build the layout
      def build_layout
        add_line_header(
            'Catalogue : exportations depuis Gescom')
        @layout.add_widget(CatalogTable.new)
        add_line

        add_line_header(
            'Catalogue : compte-rendu des importations automatiques dans Jacinthe')
        @layout.add_widget(WatcherTable.new(CATALOG_COMMANDS))
        add_line
      end

      # @return [[integer] * 4] geometry of mother window
      def geometry
        if Utils.on_mac?
          [0, 100, 1300, 500]
        else
          [100, 100, 900, 320]
        end
      end

      # @return [String] name of manager specialty
      def subtitle
        'Manager du catalogue de Jacinthe'
      end

      # SLOT : show help MessageBox
      def help
        Qt::MessageBox.information(self,
                                   'le Manageur du Catalogue',
                                   CATALOG_HELP)
      end
    end
  end
end
