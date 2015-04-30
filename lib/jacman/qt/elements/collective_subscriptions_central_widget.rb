#!/usr/bin/env ruby
# encoding: utf-8

# File: collective_subscriptions_central_widget.rb
# Created: 29 april 2015
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # Central widget for collective subscriptions
    class CollectiveSubscriptionsCentralWidget < CentralWidget
      # version of the collective_manager
      VERSION = '0.1.1'

      # "About" message
      ABOUT = ['Versions :',
               "   jacman-qt : #{JacintheManagement::VERSION}",
               "   jacman-utils : #{JacintheManagement::Utils::VERSION}",
               "   jacman_coll : #{JacintheManagement::Coll::VERSION}",
               "   collective subscriptions manager : #{VERSION}",
               'S.M.F. 2015',
               "\u00A9 Michel Demazure, LICENCE M.I.T."]

      SIGNAL_EDITING_FINISHED = SIGNAL('editingFinished()')
      SIGNAL_CLICKED = SIGNAL(:clicked)

      # @return [[Integer] * 4] geometry of mother window
      def geometry
        if Utils.on_mac?
          [100, 100, 600, 650]
        else
          [100, 100, 400, 500]
        end
      end

      # @return [String] name of manager specialty
      def subtitle
        'Management des abonnements collectifs'
      end

      # @return [Array<String>] about message
      def about
        [subtitle] + ABOUT
      end

      # build the layout
      def build_layout
        init_values
        build_name_line
        build_client_line
        build_journal_choices
        build_report_area
        build_command_area
      end

      # fix initial values
      def init_values
        @year = Coll::YEAR.to_s
        @journals = Coll.journals
      end

      # build the corresponding part
      def build_name_line
        @layout.add_widget(Qt::Label.new("<b>L'abonnement</b>"))
        box = Qt::HBoxLayout.new
        @layout.add_layout(box)
        box.add_widget(Qt::Label.new('Nom :'))
        name_field = Qt::LineEdit.new
        box.add_widget(name_field)
        connect(name_field, SIGNAL_EDITING_FINISHED) { @name = name_field.text.strip }
        box.add_widget(Qt::Label.new('Année :'))
        year_field = Qt::LineEdit.new(@year.to_s)
        box.add_widget(year_field)
        connect(year_field, SIGNAL_EDITING_FINISHED) { @year = name_field.text.strip }
      end

      # build the corresponding part
      def build_client_line
        @layout.add_widget(Qt::Label.new('<b>Le financeur</b>'))
        box = Qt::HBoxLayout.new
        @layout.add_layout(box)
        box.add_widget(Qt::Label.new('Client :'))
        client = Qt::LineEdit.new
        box.add_widget(client)
        connect(client, SIGNAL_EDITING_FINISHED) do
          @provider = fetch_client(client.text.strip)
        end
        box.add_widget(Qt::Label.new('Facture :'))
        billing = Qt::LineEdit.new
        box.add_widget(billing)
        connect(billing, SIGNAL_EDITING_FINISHED) { @billing = billing.text.strip }
      end

      # check if given client exists in DB and return its id
      #
      # @param [String] client id given by user
      # @return [String | nil] valid client_id or nil
      def fetch_client(client)
        return if client == @provider
        if Coll.fetch_client(client)
          @provider = client
          report("Client #{@provider} identifié")
          client
        else
          error('Ce client n\'existe pas')
          nil
        end
      end

      # build the corresponding part
      def build_journal_choices
        @selections = {}
        @layout.add_widget(Qt::Label.new('<b> Les revues</b>'))
        @journals.each_with_index do |(_, journal), idx|
          next unless journal
          box = Qt::HBoxLayout.new
          @layout.add_layout(box)
          check = Qt::CheckBox.new
          connect(check, SIGNAL_CLICKED) { @selections[idx] = check.checked? }
          box.add_widget(check)
          box.add_widget(Qt::Label.new(journal))
          box.add_stretch
        end
      end

      # build the corresponding part
      def build_report_area
        @report = Qt::TextEdit.new('')
        @layout.add_widget(@report)
        @report.read_only = true
      end

      # build the corresponding part
      def build_command_area
        @layout.add_widget(Qt::Label.new('<b>Actions</b>'))
        box = Qt::HBoxLayout.new
        @layout.add_layout(box)
        essai = Qt::PushButton.new('essai')
        connect(essai, SIGNAL_CLICKED) { essai_report }
        box.add_widget(essai)
      end

      # check if variable has got a correct value
      #
      # @param [String] variable who should be non blank
      # @param [String] term name fur the user
      # @return [Bool] whether variable exists and not blank
      def check(variable, term)
        return true if variable && !variable.empty?
        error("Pas de #{term}")
        false
      end

      # build collective if possible and report
      #
      # @return [CollectiveSubscription] collective built
      def build_collective
        return false unless check(@provider, 'client') &&
            check(@name, 'nom de l\'abonnement') &&
            check(@billing, 'facture') &&
            check(@year, 'année')
        journal_ids = @selections.select { |_, bool| bool }.map { |key, _| key }.sort
        report 'Abonnement collectif créé'
        Coll::CollectiveSubscription.new(@name, @provider, @billing, journal_ids, @year.to_i)
      end

      def essai_report
        @collective = build_collective
        return unless @collective

        report @collective.inspect
      end

      # show an error message
      # @param [String] message message to show
      def error(message)
        @report.append("<font color=red><b>" 'ERREUR</b> : </color> ' + message)
      end

      # show an report message
      # @param [String] message message to show
      def report(message)
        @report.append(message)
      end

      # WARNING: overrides the common one, useless in this case
      def update_values
      end

      # FIXME: add help
      #  slot help command
      def help
        puts 'add help'
      end
    end
  end
end
__END__

      # slot: a filename has been selected
      # @param [String] name name of file
      def file_selected(name)
        if @no_change || @saved_index == 0 || GuiQt.confirm_dialog(confirm_text)
          change_selection(name)
        else
          @selection.set_current_index(@saved_index)
        end
      end

      # update the GUI with the new selected file
      # @param [String] name name of file
      def change_selection(name)
        @saved_index = @selection.current_index
        if name == FIRST_LINE
          empty_values
          return
        end
        @file = SQLFiles::Source.new(name)
        update_content
        update_infos
      end

      # slot: save infos in JSON file after confirmation dialog
      def save_infos
        return unless GuiQt.confirm_dialog('Enregistrer les modifications')
        do_save_infos
      end

      # save the infos in JSON file
      def do_save_infos
        @file.save_json_info(@new_info)
        JacintheManagement.log("saved new infos for #{@file.name}")
        info_edited
      end

      # @return [String] text to ask for confirmation
      def confirm_text
        [
            "Les informations sur le fichier  <b>#{@file.name}.sql</b> ",
            'ont été modifiées, mais n\'ont pas été enregistrées.',
            'Voulez-vous vraiment ignorer ces modifications ?'
        ].join("\n")
      end

