#!/usr/bin/env ruby
# encoding: utf-8

# File: manager_help.rb
# Created:  06/10/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Help texts and slots for manager
    module ManagerHelp
      # general manager help
      MANAGER_HELP = <<MANAGER_HELP_END

Le manager de Jacinthe comporte trois zones consacrées respectivement à :
-  la surveillance des opérations lancées automatiquement,
-  la surveillance des diverses opérations de gestion,
-  les commandes permettant de lancer ces opérations.

Chaque zone possède un bouton d'aide spécifique.
MANAGER_HELP_END

      # help for night commands
      NIGHT_HELP = <<NIGHT_HELP_END
Cette zone est consacrée à la surveillance des opérations exécutées
automatiquement par le serveur, les cinq premières chaque nuit, la
dernière à chaque écriture du fichier des ventes.

Normalement, les cinq premiers indicateurs doivent être verts,
le dernier vert ou jaune.

Un indicateur jaune signale que l'opération n'a pas été exécutée dans
les dernières 24 heures, un indicateur rouge qu'il y a eu une erreur.
Dans ces deux cas, merci de prévenir le gestionnaire du serveur.
NIGHT_HELP_END

      # help for pending commands
      PENDING_HELP = <<PENDING_HELP_END
Cette zone est consacrée à la surveillance des diverses opérations de gestion.

Le code de couleur est le suivant :
-  vert : rien à faire, rien d'anormal.
-  jaune : il y quelque chose à faire
           le cas échéant, un fichier d'anomalie est consultable
-  rouge : retard anormal (pour l'écriture du fichier des ventes).

Les diverses opérations sont :
-  Fichier des ventes : date de la dernière écriture par Gescom.
-  Ventes non importées : lors de la dernière importation.
-  Fichier client : présence d'un fichier 'ClientSage'
                    exporté par Jacinthe et non revenu.
-  Nouveaux clients : présence dans la base de clients à exporter.
-  Notifications : présence dans la base d'abonnements (élec.) non notifiés.
-  Plages non valides : détectées lors de la dernière exportation.
-  Abonnés sans mail : détectés lors de la dernière notification.
PENDING_HELP_END

      # help for commands
      CMD_HELP = <<END_CMD_HELP
Cette zone permet de lancer les diverses commandes utilitaires.

En passant la souris sur le titre d'une commande, on obtiendra un peu plus de détails.

Le bouton "Description" fournit une information complémentaire.

On lance la commande par le bouton "Exécuter".
La ligne en dessous affiche "En cours", puis "Succès" ou "Echec".

Dans la zone inférieure sont affichées en temps réel les compte-rendus éventuels
de la commande et notamment, le cas échéant, les erreurs.

Le site <https://bitbucket.org/mdemazure/jacman/issues/new>
permet de rendre compte des erreurs.
END_CMD_HELP

      # SLOT : show help MessageBox for automatic commands
      def help_night
        Qt::MessageBox.information(self, 'Opérations automatiques', NIGHT_HELP)
      end

      # SLOT : show help MessageBox for pending operations
      def help_pending
        Qt::MessageBox.information(self, 'Opérations pendantes', PENDING_HELP)
      end

      # SLOT : show help MessageBox for commands
      def help_cmd
        Qt::MessageBox.information(self, 'Les commandes', CMD_HELP)
      end

      # HTML hem file
      HELP_FILE = File.expand_path('manager.html',
                                   File.join(File.dirname(__FILE__), '../../..', 'help'))

      # SLOT : show help MessageBox for manager
      def help
        #  Qt::MessageBox.information(self, 'le Manageur de Jacinthe', MANAGER_HELP)
        Core::Utils.open_file(HELP_FILE)
      end
    end
  end
end
