#!/usr/bin/env ruby
# encoding: utf-8
#
# File: sqlfiles.rb
# Created: 01 January 2015
#
# (c) Michel Demazure <michel@demazure.com>

require 'json'

module JacintheManagement
  module SQLFiles
    KEYS = {
        object: 'Objet :',
        security: 'Risques :',
        return_type: 'Type de la réponse :',
        return: 'Contenu de la réponse :',
        token: 'Jeton :',
        remark: 'Remarque :',
        used_in_gem: 'Utilisé dans le gem :',
        used_in_file: 'Utilisé dans le fichier :',
        used_in_method: 'Utilisé dans la méthode :'
    }

    TYPES = %w(Inconnu Requête Commande Fragment)

    # SQl source files
    class Source
      # @return [Array] base_names (without .sql) of all script files
      def self.all
        Dir.glob(Core::SQL_SCRIPT_DIR + '/**/*.sql').map do |path|
          File.basename(path, '.sql')
        end
      end

      attr_reader :info, :name, :content

      def initialize(name)
        @name = name
        @path = Dir.glob(Core::SQL_SCRIPT_DIR + "/**/#{name}.sql").first
        @content = File.read(@path, encoding: 'utf-8')
        @json_file = @path.sub('.sql', '.json')
        @info = fetch_json_info
      end

      # FIXME: should not be used
      # FIXME: or copy the source from utils
      def script
        JacintheManagement::SqlScriptFile.new(@name).script
      end

      def type_index
        TYPES.index(@info[:type]) || 0
      end

      def executable?
        @info[:type] == TYPES[1]
      end

      def save_json_info(new_info)
        File.open(@json_file, 'w:utf-8') do |file|
          file.puts(new_info.to_json)
        end
        @info = new_info
      end

      def fetch_json_info
        return {} unless File.exist?(@json_file)
        content = File.read(@json_file, encoding: 'utf-8')
        JSON.parse(content, symbolize_names: true)
      end
    end
  end
end
