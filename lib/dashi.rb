require "dashi/version"
require "bonito"
require "konbu"
require "sauce_whisk"
require "logger"
require "active_support/inflector"
require_relative "dashi/sauce_log"
require_relative "dashi/ruby_formatter"
require_relative "dashi/test_template"
require_relative "dashi/element_namer"

module Dashi
  class << self
    def logger
      @@logger ||= Logger.new(STDOUT)
    end

    def recreate_from_file filename, formatter = Formatter::Ruby, output_filename
      Dashi.logger.info "Asked to recreate job from #{filename} using #{formatter}"
      sauce_log = File.read filename

      recreate sauce_log, formatter, output_filename
    end

    def recreate_from_session_id session_id, formatter = Formatter::Ruby, output_filename
      Dashi.logger.info "Asked to recreate job from #{session_id} using #{formatter}"
      Bonito.logger.level = Logger::WARN
      Dashi.logger.level = Logger::WARN

      sauce_log = SauceLog.new.sauce_log :id => session_id
      recreate sauce_log, formatter, output_filename, session_id
    end

    def recreate job_content, formatter, output_filename, session_id = nil
      command_list = Konbu.rehydrate job_content
      test = Bonito::Test.new command_list, []

      test_script = test.ruled_commands.map do |command|
        match_command_to_formatter(command, formatter).new(command, test).format
      end

      capabilities = {}
      if session_id
        sauce_job = SauceWhisk::Jobs.fetch session_id

        capabilities = {
          :browserName => sauce_job.browser,
          :version => sauce_job.browser_version,
          :platform => sauce_job.os
        }
      else
        capabilities = test.desired_capabilities
      end

      template = TestTemplate.new capabilities, test_script, File.join(File.dirname(__FILE__), 'dashi', 'test_shell.rb.erb')
      template.write (output_filename)
      puts "Wrote regenerated test to #{output_filename}.  IT'S ALLLLIIIIVE!"
    end

    def match_command_to_formatter command, formatter
      command_name = command_name_from_class command
      formatter_name = rename_command command_name
      fm = formatter.const_get formatter_name, false
      return fm
    end

    def command_name_from_class command
      command.class.to_s.demodulize.to_sym
    end

    def rename_command command_name
      renamed_commands.fetch(command_name.to_sym, command_name)
    end

    def renamed_commands
      {
        :LoadResourceCommand => "Get"
      }
    end

    def default_namer
      @default_namer ||= SequentialElementNamer.new
    end
  end
end
