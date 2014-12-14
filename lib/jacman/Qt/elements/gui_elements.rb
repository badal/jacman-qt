#!/usr/bin/env ruby
# encoding: utf-8

# File: gui_elements.rb
# Created: 21/06/12
#
# (c) Michel Demazure <michel@demazure.com>

module JacintheManagement
  # all classes and methods for both GUIs
  module GuiQt
    YELLOW = '#FF0'
    GREEN = '#AFA'
    RED = '#F00'
    BLUE = '#CDF'

    # Open a popup for displaying a file
    # @param [String] title title of popup
    # @param [Paths] file file to show
    # @param [Qt element] parent widget
    def self.show_file(parent, title, file)
      text = File.read(file).force_encoding('utf-8')
      Qt::MessageBox.information(parent, title, text)
    end

    # Class of styled frames
    class EmptyFrame < Qt::Frame
      # Build a new frame
      def initialize
        super
        set_shape
      end

      # Build the frame shape
      def set_shape
        # set_size_policy(qt::SizePolicy::Fixed, qt::SizePolicy::Fixed)
        set_minimum_size(160, 90)
        self.frame_shape = Qt::Frame::StyledPanel
        self.frame_shadow = Qt::Frame::Sunken
        self.line_width = 2
        self.auto_fill_background = true
      end

      # Fix the frame color
      # @param [String] color hes string for color
      def set_color(color)
        palette = Qt::Palette.new
        palette.set_color(background_role, Qt::Color.new(color))
        self.palette = palette
      end
    end

    # Horizontal line format
    class HLine < Qt::Frame
      # A new horizontal line
      def initialize
        super()
        set_frame_shape(Qt::Frame::HLine)
        set_frame_shadow(Qt::Frame::Raised)
      end
    end
  end
end
