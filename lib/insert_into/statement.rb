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

    def returning(statement)
      @returning = statement
    end

    def to_sql
      "INSERT INTO #{table_name} (#{all_column_names.join(',')}) VALUES #{values_string}#{returning_values};"
    end

    private

    def all_column_names
      @rows.flat_map(&:column_names).uniq
    end

    def values_string
      @rows.map do |row|
        "(#{formatted_row(row)})"
      end.join(',')
    end

    def returning_values
      " RETURNING #{@returning}" if @returning
    end

    def formatted_row(row)
      all_column_names.map { |col| formatted_value(row[col]) }.join(',')
    end

    def formatted_value(v)
      if v.nil?
        "NULL"
      elsif v.kind_of?(String)
        "\'#{v}\'"
      elsif v.kind_of?(Hash)
        "$JSON$#{JSON.generate(v)}$JSON$"
      else
        v
      end
    end
  end
end
