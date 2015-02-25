module InsertInto
  class Row
    def initialize
      @data = {}
    end

    def column_names
      @data.keys
    end

    def [](key)
      @data[key]
    end

    def method_missing(m, *args, &block)
      @data[m] = args[0]
    end
  end
end
