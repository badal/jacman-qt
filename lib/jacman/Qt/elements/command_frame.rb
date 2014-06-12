#!/usr/bin/env ruby
# encoding: utf-8

# File: command_frame.rb
# Created: 17/08/13
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheManagement
  module GuiQt
    # Individual command frames for the manager GUI
    class CommandFrame < EmptyFrame
      slots :written, :execute, :help
      signals :output_written

      # @return[CommandFrame] frame for this command
      # @param[String] cmd call_name of command
      def self.with(cmd)
        new(Core::Command.fetch(cmd))
      end

      # @param[String] the received text
      attr_reader :received

      # @param [Core::Command] command
      def initialize(command)
        super()
        @command = command
        @received = nil
        # noinspection RubyArgCount
        @str = GuiQt::Stream.new
        connect(@str, SIGNAL(:written), self, SLOT(:written))
        set_color(BLUE)
        build_layout
      end

      # Build the layout
      def build_layout
        layout = Qt::VBoxLayout.new(self)
        # noinspection RubyArgCount
        label = Qt::Label.new("<b> #{@command.title}</b>")
        label.alignment = Qt::AlignHCenter
        label.tool_tip = @command.long_title.join("\n")
        layout.add_widget(label)
        layout.add_layout(buttons_layout)
        @answer = Qt::LineEdit.new
        layout.add_widget(@answer)
      end

      # Build the buttons layout
      # @return [Qt::HBoxLayout] buttons layout
      def buttons_layout
        buttons = Qt::HBoxLayout.new
        # noinspection RubyArgCount
        @button = Qt::PushButton.new('Exécuter')
        @button.setStyleSheet('* { background-color: rgb(255, 200, 200) }')
        buttons.add_widget(@button)
        connect(@button, SIGNAL(:clicked), self, SLOT(:execute))
        # noinspection RubyArgCount
        help_button = Qt::PushButton.new('Description')
        buttons.add_widget(help_button)
        connect(help_button, SIGNAL(:clicked), self, SLOT(:help))
        buttons
      end

      # Slot : execute the command and redirect the output to the inside stream
      def execute
        @answer.set_text('En cours')
        Qt::CoreApplication.process_events
        $stdout = @str
        puts "<b>------  Exécution de la commande '#{@command.title}'<\b>"
        puts ''
        @answer.text = @command.execute ? 'Succès' : 'ERREUR'
        puts '<b>------  Exécution terminée</b>'
        puts ''
        $stdout = STDOUT
      end

      # Slot : emit the signal 'output written'
      def written
        @received = @str.received
        emit(output_written)
      end

      # Slot : open the help MessageBox for this command
      def help
        text = "La commande \"#{@command.title}\"\n\n#{@command.help_text}"
        Qt::MessageBox.information(self, @command.title, text)
      end

      # enable/disable the execute button
      # @param [Boolean] bool whether the button has to be enabled
      def enabled=(bool)
        @button.enabled = bool
      end
    end
  end
end
