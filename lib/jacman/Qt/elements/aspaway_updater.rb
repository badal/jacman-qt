#!/usr/bin/env ruby
# encoding: utf-8

# File: aspaway_importer.rb
# Created: 20/11/13
#
# (c) Michel Demazure <michel@demazure.com>

# script methods for Jacinthe Management
module JacintheManagement
  module GuiQt
    # for automatic fetching of Aspaway files
    class AspawayUpdater
      # @return [Integer] age in (full) hours of source file
      attr_reader :source_age

      # @param [String] source_file path of file written by Sage wrto transfer dir
      # @param [String] call_name call name of importation method
      def initialize(source_file, call_name)
        @importer = Core::AspawayImporter.new(source_file)
        @source_age = nil
        @stamp = File.join(CRON_DIR, "stdout_#{call_name}.txt")
        @call_name = call_name
      end

      # WARNING: this is stronger than @importer.returned because it checks for
      #   completion of importation and not only of fetch
      # Update source_age and say if import is needed
      # @return [Bool] whether importation is to be made
      def need_update
        return false if @updating # protecting
        source_time = @importer.time_of_file
        @source_age = Core::Utils.delay(source_time).to_i
        !File.exist?(@stamp) || source_time > File.mtime(@stamp)
      end

      # Import command
      def update
        return if @updating
        @updating = true
        puts "Automatic updating : running command #{@call_name}"
        Core::Command.cron_run(@call_name)
        # FileUtils.touch(@stamp)
        @updating = false
      end
    end
  end
end
