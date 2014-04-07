#!/usr/bin/env ruby
# encoding: utf-8

# File: stream.rb
# Created: 17/08/13
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheManagement
  module GuiQt
    # Class to capture stdout
    class Stream < Qt::Object
      signals :written

      # @param[String, nil] the captured text
      attr_reader :received

      # A new stream
      def initialize
        super
        @received = nil
      end

      # Capture to @received the text written to stdout
      #   and emit the 'written' signal
      # @param [String] text text received
      def write(text)
        @received = text
        emit(written)
      end

      # Empty method for Mac server
      def flush
      end
    end
  end
end
