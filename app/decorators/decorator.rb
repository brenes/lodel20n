puts "ZORG"
module Decorators
  class Base
    def initialize(decorated)
      @decorated = decorated
    end

    def method_missing(s, *a)
      @decorated.send(s, *a)
    end
  end
end