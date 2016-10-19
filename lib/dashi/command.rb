module Dashi
  class Command
  
    attr_reader :formatter

    def initialize formatter
      STDERR.puts "I am #{self}"
      @formatter = formatter
    end

    def output
      formatter.call self
    end
  end
end