require 'tilt'

module Dashi
  class TestTemplate
    attr_accessor :desired_capabilities, :commands
    attr_reader :template_filename

    def initialize desired_capabilities, commands, template_filename
      @desired_capabilities = desired_capabilities
      @commands = commands
      @template_filename = Pathname(template_filename)
    end

    def render
      template = Tilt.new template_filename
      template.render self
    end

    def write filename
      File.open(Pathname(filename), 'w') { |file| file.write(render) }
    end

    def commands_for_execution
      non_setup_commands = commands[1..-1]
      non_setup_commands.join "\n"
    end
  end
end