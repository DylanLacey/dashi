module Dashi
  module ElementNamer

    attr_reader :names

    def initialize
      @names = {}
    end

    def name element
      name = generate_name element
      names[element] = name

      return name
    end

    def find_name element
      name = names[element] || nil
    end

    def find_or_create_name element
      found_name = find_name
      return name element if found_name.nil?
      return found_name
    end

    private 

    def generate_name element
      raise TypeError "don't use ElementNamer directly; If you don't care, use RandomElementNamer"
    end
  end

  class RandomElementNamer
    include ElementNamer

    def generate_name element
      ('a'..'z').to_a.shuffle[0,8].join
    end
  end
end