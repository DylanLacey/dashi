module Dashi
	module Formatter
    module Lang
    end

    class Command
      @language_method = 'Nothing'

      class << self
        attr_accessor :language_method, :is_element
      end

      attr_accessor :string_quoter, :argument_separator, :language_method, :command, :driver_name

      def initialize command, test, opts={}
        @command = command
        @string_quoter ||= '"'
        @argument_separator ||= ', '
        @driver_name ||= 'driver'
      end

      # Wrap strings in quotes; Otherwise return the value
      def wrap_if_required string_to_wrap
        case string_to_wrap
        when -> (a) { [URI::HTTP, String].include? a.class }
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
        argument = [command.to_arguments_hash.values.first]
        combine_and_wrap_arguments argument
      end
      
      def format
        arguments = format_arguments
        language_method = self.class.language_method

        method_call = "#{driver_name}.#{language_method} #{arguments}"
        method_call.prepend "element = " if self.class.is_element
        return method_call
      end
    end
	end
end