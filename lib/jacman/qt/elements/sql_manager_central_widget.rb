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
    class SqlManagerCentralWidget < CentralWidget
      # version of the notifier
      VERSION = '0.1.4'

      # "About" message
      ABOUT = ['Versions',
               "   jacman-qt : #{JacintheManagement::VERSION}",
               "   jacman-utils : #{JacintheManagement::Utils::VERSION}",
               "   sql_manager : #{VERSION}",
               'S.M.F. 2014-2015',
               "\u00A9 Michel Demazure, LICENCE M.I.T."]

      FIRST_LINE = 'Choisir un fichier'
      NEANT = '---'

      slots 'file_selected(const QString&)', :info_edited, :save_infos, :execute

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
        'Management des fichiers de requête'
      end

      # @return [Array<String>] about message
      def about
        [subtitle] + ABOUT
      end

      # build the layout
      def build_layout
        @info_values = {}
        @no_change = true
        @saved_index = 0
        build_selection_line
        build_type_line
        build_info_zone
        build_modif_line
        build_content_zone
        @layout.addStretch
        @save_button.enabled = false
      end

      def build_type_line
        box = Qt::HBoxLayout.new
        @layout.add_layout(box)
        @type = Qt::ComboBox.new
        @type.add_items(SQLFiles::TYPES)
        box.add_widget(Qt::Label.new('Type :'))
        box.add_widget(@type)
        connect(@type, SIGNAL('activated(int)'), self, SLOT(:info_edited))
      end

      def build_selection_line
        list = [FIRST_LINE] + SQLFiles::Source.all
        @selection = Qt::ComboBox.new
        @selection.add_items(list)
        @layout.add_widget(@selection)
        connect(@selection, SIGNAL('activated(const QString&)'), self, SLOT('file_selected(const QString&)'))
      end

      def build_info_zone
        SQLFiles::KEYS.each_pair do |key, value|
          @info_values[key] = Qt::LineEdit.new(NEANT)
          box = Qt::HBoxLayout.new
          @layout.add_layout(box)
          label = Qt::Label.new(value.to_s)
          box.add_widget(label)
          box.add_widget(@info_values[key])
          connect(@info_values[key], SIGNAL('textChanged(const QString&)'), self, SLOT(:info_edited))
        end
      end

      def build_content_zone
        @content = Qt::TextEdit.new
        @layout.add_widget(@content)
        @content.read_only = true
      end

      def build_modif_line
        box = Qt::HBoxLayout.new
        @modif = Qt::Label.new('')
        box.add_widget(@modif)
        @save_button = Qt::PushButton.new('Enregistrer les modifications')
        box.add_widget(@save_button)
        connect(@save_button, SIGNAL(:clicked), self, SLOT(:save_infos))
        @exec_button = Qt::PushButton.new('Exécuter')
        box.add_widget(@exec_button)
        @exec_button.enabled = false
        connect(@exec_button, SIGNAL(:clicked), self, SLOT(:execute))
        @layout.add_layout(box)
      end

      def empty_values
        @type.current_index = 0
        SQLFiles::KEYS.each_key do |key|
          @info_values[key].text = NEANT
        end
        @content.text = ''
      end

      def file_selected(string)
        if @no_change || @saved_index == 0 || GuiQt.confirm_dialog(confirm_text)
          change_selection(string)
        else
          @selection.set_current_index(@saved_index)
        end
      end

      def change_selection(string)
        @saved_index = @selection.current_index
        if string == FIRST_LINE
          empty_values
          return
        end
        @file = SQLFiles::Source.new(string)
        update_content
        update_infos
      end

      def info_edited
        build_new_info
        @no_change = (@new_info == @file.info) || (@saved_index == 0)
        @modif.text = @no_change ? '' : '<b>Informations modifiées</b>'
        @save_button.enabled = !@no_change
      end

      def save_infos
        return unless GuiQt.confirm_dialog('Enregistrer les modifications')
        do_save_infos
      end

      def do_save_infos
        @file.save_json_info(@new_info)
        JacintheManagement.log("saved new infos for #{@file.name}")
        info_edited
      end

      def confirm_text
        [
            "Les informations sur le fichier  <b>#{@file.name}.sql</b> ",
            'ont été modifiées, mais n\'ont pas été enregistrées.',
            'Voulez-vous vraiment ignorer ces modifications ?'
        ].join("\n")
      end

      def build_new_info
        @new_info = {}
        @new_info[:type] = @type.current_text.force_encoding('utf-8')
        SQLFiles::KEYS.each_key do |key|
          new_text = @info_values[key].text.force_encoding('utf-8').strip
          next if new_text == NEANT
          @new_info[key] = new_text
        end
      end

      def update_content
        @content.text = @file.content
      end

      def update_infos
        @type.set_current_index(@file.type_index)
        @info_values.each_pair do |key, line|
          line.text = @file.info[key] || NEANT
        end
        @exec_button.enabled = @file.executable?
      end

      def execute
        answer = Sql.answer_to_query(JACINTHE_MODE, @file.script).join
        Qt::MessageBox.information(parent, 'Réponse', answer)
      end

      # FIXME: add help
      #  slot help command
      def help
        puts 'add help'
      end
    end
  end
end
