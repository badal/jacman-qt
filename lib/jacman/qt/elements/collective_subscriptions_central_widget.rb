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
        @subscriber = nil
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
        create_collective = Qt::PushButton.new('Créer l\'abo. coll.')
        connect(create_collective, SIGNAL_CLICKED) { @subscriber = build_subscriber }
        box.add_widget(create_collective)
        load_tiers = Qt::PushButton.new('Lire liste de tiers')
        connect(load_tiers, SIGNAL_CLICKED) { add_tiers_list }
        box.add_widget(load_tiers)
        process = Qt::PushButton.new('Créer les abonnements')
        connect(process, SIGNAL_CLICKED) { process_collective }
        box.add_widget(process)
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

      # show an error message
      # @param [String] message message to show
      def error(message)
        @report.append('<font color=red><b>' 'ERREUR</b> : </color> ' + message)
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

      ## Controller methods

      # check if variable has got a correct value
      #
      # @param [String] variable who should be non blank
      # @param [String] term name for the user
      # @return [Bool] whether variable exists and not blank
      def check(variable, term)
        return true if variable && !variable.empty?
        error("Pas de #{term}")
        false
      end

      # build collective if possible and report
      #
      # @return [Subscriber | nil] collective subscriber built
      def build_subscriber
        return nil unless check(@provider, 'client') &&
            check(@name, 'nom de l\'abonnement') &&
            check(@billing, 'facture') &&
            check(@year, 'année')
        journal_ids = @selections.select { |_, bool| bool }.map { |key, _| key }.sort
        if journal_ids.size == 0
          error 'pas de revues'
          return
        end
        report 'Abonnement collectif créé'
        coll = Coll::CollectiveSubscription.new(@name, @provider, @billing, journal_ids, @year.to_i)
        Coll::Subscriber.new(coll)
      end

      # ask for a file, read it and return lines consisting of a integer
      #
      # @return [Array<Integer>] list of tiers id
      def read_tiers_list_file
        filename = Qt::FileDialog.getOpenFileName(self,
                                                  'Charger une liste de tiers',
                                                  '',
                                                  '')
        return [] unless filename
        File.readlines(filename)
      end

      # ask for a file, read it and return lines consisting of a integer
      #   with error management
      # @return [Array<Integer>] list of tiers id
      def load_tiers_list
        lines = read_tiers_list_file
        tiers_list = lines.map { |line| line.strip.to_i }.sort.uniq.select { |val| val > 0 }
        if tiers_list.size > 0
          report "Liste : #{tiers_list.size} tiers"
        else
          error 'Liste vide'
        end
        tiers_list
      end

      # add a tiers list to @collective
      #
      def add_tiers_list
        unless @subscriber
          error 'Créer l\'abonnement collectif'
          return
        end
        tiers_list = load_tiers_list
        return unless tiers_list.size > 0
        rpt = @subscriber.add_tiers_list(tiers_list)
        rpt.each { |line| error(line) }
        report "#{@subscriber.client_list.size} tiers/clients"
      end

      # FIXME: temporary
      def process_collective
        subs, errors = *@subscriber.process
        subs.each { |line| report line }
        if errors.size > 1
          error "Tiers sans mail"
          errors.each { |line| report line }
        end
      end
    end
  end
end
