require_relative "element_namer"

module Dashi
	module Formatter
    module Lang
      module ClassModules
        def no_argument_command klass, command
          const_set klass, Class.new(Command) {}
        end

        def single_argument_command klass, command
          const_set klass, Class.new(Command) { @language_method = command }
        end
      end


      def self.included base_module
        base_module.extend ClassModules
      end
    end

    # Maybe this entire thing is awful and I should be using a #render strategy the whole way through
    # inc. some sort of hand-made partial support.
    #
    # That's probably friendliest
    class Command
      @language_method = 'Nothing'

      class << self
        attr_accessor :language_method, :is_element, :is_assignment, :is_external_assignment
      end

      attr_accessor :string_quoter, :argument_separator, :language_method, :command, :driver_name
      attr_reader = :namer

      def initialize command, test, namer = Dashi.default_namer, opts={}
        #STDERR.puts "Creating command for #{command} - #{self.class.language_method}"
        @command = command
        @string_quoter ||= '"'
        @argument_separator ||= ', '
        @driver_name ||= 'driver'
        @namer = namer
      end

      # Wrap strings in quotes; Otherwise return the value
      def wrap_if_required string_to_wrap
        case string_to_wrap
        when -> (a) { [URI::HTTP, URI::HTTPS, String].include? a.class }
          quoted_string = string_quoter.dup
          quoted_string << string_to_wrap.to_s
          quoted_string << string_quoter
          return quoted_string
        when -> (a) { [Symbol].include? a.class }
          return string_to_wrap.inspect
        else
          string_to_wrap
        end
      end

      def combine_and_wrap_arguments arguments
        wrapped_arguments = arguments.map {|a| wrap_if_required a}
        wrapped_arguments.join @argument_separator
      end
          

      def format_arguments 
        if command.respond_to? :to_arguments_hash
          argument = [command.to_arguments_hash.values.first]
          return combine_and_wrap_arguments argument
        end
        ""
      end
      
      def format
        arguments = format_arguments
        language_method = self.class.language_method

        method_call = "#{language_method} #{arguments}"
        prepend_string = ""
        # This really belongs in another class; Either the Command or a Formatter
        if self.class.is_element
          if self.class.is_assignment
            element_name = @namer.name command.element

            # This needs to be some sort of Type formatter for Java and Friends.
            # Poor Java and Friends.
            prepend_string = "#{element_name} = #{driver_name}."
          else
            puts "Finding #{command.element} for #{language_method}"
            element_name = @namer.find_name command.element
            # Element name doesn't _really_ belong in the ElementCommands
            prepend_string = "#{element_name}."

            if self.class.is_external_assignment
              variable_name = @namer.name command.element_id, :variable
              prepend_string = "#{variable_name} = #{prepend_string}"
            end
          end
        else
          prepend_string = "#{driver_name}."
        end

        method_call.prepend prepend_string

        return method_call
      end

      # Generate a random name for now;  We'll get smarter later
      def new_element_name
        ('a'..'z').to_a.shuffle[0,8].join
      end

      def find_element_name command
        command.element_name
      end
    end
	end
end