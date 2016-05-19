require_relative 'formatter'

module Dashi
  module Formatter
    module Lang
      module Ruby
        def language
          "Ruby"
        end

        class Formatter::Lang::Ruby::Get < Command
          @language_method = 'get'
        end

        class Formatter::Lang::Ruby::NewSessionCommand < Command
          def format
          end
        end

        class Formatter::Lang::Ruby::GenericCommand < Command; end
        class Formatter::Lang::Ruby::QuitCommand < Command
          @language_method = 'quit'
        end

        class ElementLocationCommand < Command
          @language_method = 'find_element'
          @is_element = true
          @is_assignment = true

          def format_arguments 
            original_arguments = command.to_arguments_hash
            strategy = original_arguments.fetch :strategy
            search_term = original_arguments.fetch :search_term

            combine_and_wrap_arguments [strategy, search_term]
          end
        end

        class SendKeysToElement < Command
          @language_method = 'send_keys'
          @is_element = true
          @is_assignment = false
        end

        class ClickElementCommand < Command
          @language_method = 'click'
          @is_element = true

          def format_arguments
            ""
          end
        end
      end
    end
  end
end