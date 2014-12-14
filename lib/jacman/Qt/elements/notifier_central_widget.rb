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
    class NotifierCentralWidget < CentralWidget
      slots :update_selection, :confirm

      # format for *caption_text*
      FMT = '%3d '

      # @return [[Integer] * 4] geometry of mother window
      def geometry
        if Utils.on_mac?
          [100, 100, 600, 900]
        else
          [100, 100, 400, 620]
        end
      end

      # @return [String] name of manager specialty
      def subtitle
        'Notification des abonnement électroniques'
      end

      def build_layout
        build_first_line
        build_selection_area
        build_notify_command_area
        build_report_area
        update_selection
        redraw_layout
      end

      def build_report_area
        Qt::HBoxLayout.new do |box|
          @layout.add_layout(box)
          @report = Qt::TextEdit.new
          box.add_widget(@report)
        end
      end

      def build_notify_command_area
        Qt::HBoxLayout.new do |box|
          @layout.add_layout(box)
          @sel = Qt::Label.new
          box.add_widget(@sel)
          @notify_button = Qt::PushButton.new('Notifier ?')
          box.add_widget(@notify_button)
          connect(@notify_button, SIGNAL(:clicked), self, SLOT(:confirm))
        end
      end

      def build_first_line
        @number = Qt::Label.new
        @layout.add_widget(@number)
      end

      def build_selection_area
        @toto = Notifications::Base.classified_notifications
        @check_buttons = []
        @numbers = []
        @toto.each_pair.with_index do |(key, value), idx|
          Qt::HBoxLayout.new do |line|
            @layout.add_layout(line)
            @numbers[idx] = Qt::Label.new
            line.add_widget(@numbers[idx])
            Qt::CheckBox.new do |button|
              @check_buttons[idx] = button
              connect(button, SIGNAL(:clicked), self, SLOT(:update_selection))
              line.add_widget(button)
            end
            line.add_widget(Qt::Label.new(format_key(key)))
            line.addStretch
          end
        end
      end

      def update_values
      end

      def do_notify
        Notifications.notify_all(@selected_keys)
      end

      def format_key(key)
        "#{key.first} <b>[#{key.last}]</b>"
      end

      def confirm
        text = " Notifier #{@selected_size} abonnements. Confirmez"
        return unless confirm_dialog(text)
        answer = do_notify
        @report.append answer.join("\n")
        redraw_layout
        update_selection
      end

      def redraw_layout
        @selected_keys.each { |key| @toto[key] = [] }
        @toto.each_pair.with_index do |(key, value), idx|
          @numbers[idx].text = format(FMT, value.size)
          @check_buttons[idx].enabled = (value.size > 0)
        end
      end

      def update_selection
        @selected_keys = []
        @selected_size = 0
        @toto.each_pair.with_index do |(key, value), idx|
          if @check_buttons[idx].checked?
            @selected_keys << key
            @selected_size += value.size
          end
        end
        update_view
      end

      def update_view
        @sel.text = "<b>Notifier #{@selected_size} abonnements ?</b>"
        @sel.enabled = (@selected_size > 0)
        @notify_button.enabled = (@selected_size > 0)
        number = Notifications::Base.notifications_number
        @number.text = "<b>#{number} abonnements attendent notification</b>"
      end

      def confirm_dialog(message)
        message_box = Qt::MessageBox.new(Qt::MessageBox::Warning, 'Jacinthe', message)
        message_box.setWindowIcon(Icons.from_file('Board-11-Flowers-icon.png'))
        message_box.setInformativeText('Confirmez-vous ?')
        message_box.addButton('OUI', Qt::MessageBox::AcceptRole)
        no_button = message_box.addButton('NON', Qt::MessageBox::RejectRole)
        message_box.setDefaultButton(no_button)
        message_box.exec == 0
      end

      def help
        puts 'add help'
      end
    end
  end
end
