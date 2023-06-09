# encoding: utf-8
require 'avro'
require 'filewatcher'
require 'open-uri'

require 'logstash/inputs/base'
require 'logstash/namespace'
require 'logstash/event'

# == Logstash Input - Avro File
#
# This plugin is used to process AVRO File into logstash events
#
# Do not use it in multi-threaded manner, current version won't like it
#
# ==== Options
#
# - ``avro_file_path`` - path to AVRO file (wildcards are supported)
# - ``schema_path``    - path to AVRO schema to be used to decode AVRO file (for cases when schema is not present in the file)
# - ``scan_interval``  - how many seconds to wait between each file scan, defaults to 5 seconds
#
# ==== Usage
#
# input {
#   avro_file { avro_file_path => '/path/to/avro/file.avro' }
# }
#
# input {
#   avro_file { avro_file_path => '/path/to/avro/*.avro' }
# }
#

# rubocop:disable DepartmentName
class LogStash::Inputs::AvroFile < LogStash::Inputs::Base
  config_name 'avro_file'

  default :codec, 'plain' # not using any codecs in this plugin, so plain would do

  # Specify path to an AVRO file or the directory where AVRO files are located
  config :avro_file_path, validate: :string, required: true
  # Specify path to AVRO schema
  config :schema_path,    validate: :string
  # Specify how often to look for new files (in seconds)
  config :scan_interval,  validate: :number, default: 5

  def register
    @schema  = Avro::Schema.parse(URI.parse(schema_path).open.read) unless @schema_path.nil? || @schema_path.empty?
    @watcher = Filewatcher.new([@avro_file_path], interval: @scan_interval)

    @processed_files = {}
  end

  def run(queue)
    @watcher.watch do |changes|
      changes.each do |filename, event|
        @logger.info("#{filename} is #{event}")

        next if event != :created
        next if @processed_files.key? filename

        Avro::DataFile.open(filename, 'r') do |reader|
          reader.each do |avro_message|
            event = LogStash::Event.new(avro_message)
            queue << event
          end
        end
        @processed_files[filename] = 'processed'
      end
    rescue IOError, EOFError, LogStash::ShutdownSignal
      # stdin closed or a requested shutdown
      break
    end
  end

  def stop
  end
end
# rubocop:enable DepartmentName
