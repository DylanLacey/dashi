require_relative 'formatter'

module Dashi::Formatter::Ruby
  include Dashi::Formatter::Lang

  def language
    "Ruby"
  end

  no_argument_command "Orientation", "orientation"
  no_argument_command "AcceptAlert", "acceptAlert" 
  no_argument_command "DismissAlert", "dismissAlert"
  no_argument_command "GetWindowHandle", "window_handle"
  no_argument_command "GetWindowHandles", "window_handles"

  single_argument_command "ImplicitWaitCommand", "manage.timeouts.implicit_wait="
  single_argument_command "SetScriptTimeout", "manage.timeouts.script_timeout="
  single_argument_command "SetPageLoadTimeout", "manage.timeouts.page_load="
  single_argument_command "GetCurrentUrl", "current_url"
  single_argument_command "ExecuteScriptCommand", "execute_script"

  class Get < Dashi::Formatter::Command
    @language_method = 'get'
  end

  class NewSessionCommand < Dashi::Formatter::Command
    def format
    end
  end

  class GenericCommand < Dashi::Formatter::Command; end
  class QuitCommand < Dashi::Formatter::Command
    @language_method = 'quit'
  end

  class ElementLocationCommand < Dashi::Formatter::Command
    @language_method = 'find_element'
    @is_element = true
    @is_assignment = true
    @is_external_assignment = false

    def format_arguments 
      original_arguments = command.to_arguments_hash
      strategy = original_arguments.fetch :strategy
      search_term = original_arguments.fetch :search_term

      combine_and_wrap_arguments [strategy, search_term]
    end
  end

  class SendKeysToElement < Dashi::Formatter::
    Command
    @language_method = 'send_keys'
    @is_element = true
    @is_assignment = false
  end

  # Define all of the argument_less element commands
  {
    "Click" => "click", 
    "Clear" => "clear",
  }.each do |name, cmd|
    class_name = "#{name}ElementCommand"

    Dashi::Formatter::Ruby.const_set class_name, Class.new(Dashi::Formatter::Command) {
      @language_method = cmd
      @is_element = true
      @is_assignment = false
      @is_external_assignment = false

      def format_arguments
        ""
      end
    }
  end

  # Define all of the argument_less element commands that return values
  {
    "VisibilityOf" => "displayed?", 
    "CheckEnabled" => "enabled?",
    "CheckSelected" => "selected?",
    "CheckDisplayed" => "displayed?",
    "LocationOf" => "location", 
    "LocationInViewOf" => "location_in_view",
    "SizeOf" => "size", 
    "TextOf" => "text"
  }.each do |name, cmd|
    class_name = "#{name}ElementCommand"

    Dashi::Formatter::Ruby.const_set class_name, Class.new(Dashi::Formatter::Command) {
      @language_method = cmd
      @is_element = true
      @is_assignment = false
      @is_external_assignment = true

      def format_arguments
        ""
      end
    }
  end
end