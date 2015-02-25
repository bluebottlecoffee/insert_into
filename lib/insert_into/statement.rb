module InsertInto
  class Statement
    attr_reader :table_name

    def initialize(table_name)
      @table_name = table_name
      @rows = []
    end

    def new_row
      row = Row.new
      yield row
      @rows << row
    end

    def to_sql
      "INSERT INTO #{table_name} (#{column_names.join(',')}) VALUES #{values_string};"
    end

    private

    def column_names
      @rows.flat_map(&:column_names).uniq
    end

    def values_string
      @rows.map do |row|
        "(#{formatted_row(row)})"
      end.join(',')
    end

    def formatted_row(row)
      all_column_names.map do |col|
        v = row[col]

        if v.nil?
          "NULL"
        elsif v.kind_of?(String)
          "\'#{v}\'"
        elsif v.kind_of?(Hash)
          "$JSON$#{JSON.generate(v)}$JSON$"
        else
          v
        end
      end.join(',')
    end

    def all_column_names
      @rows.flat_map(&:column_names).uniq
    end
  end
end
