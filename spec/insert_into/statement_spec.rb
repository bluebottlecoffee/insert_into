require 'insert_into'

describe InsertInto::Statement do
  it 'takes a table name' do
    insert = described_class.new('people')
    expect(insert.table_name).to eq('people')
  end

  describe '#new_row' do
    subject(:insert) { described_class.new('people') }

    it 'creates a new set of values for an insert' do
      insert.new_row do |r|
        r.name 'Gregg'
      end

      expect(insert.to_sql).to eq("INSERT INTO people (name) VALUES ('Gregg');")
    end

    it 'can insert multiple columns' do
      insert.new_row do |r|
        r.name 'Gregg'
        r.city 'San Francisco'
      end

      expect(insert.to_sql).to eq("INSERT INTO people (name,city) VALUES ('Gregg','San Francisco');")
    end

    it 'can insert multiple rows with the same columns' do
      insert.new_row do |r|
        r.name 'Gregg'
      end

      insert.new_row do |r|
        r.name 'Bob'
      end

      expect(insert.to_sql).to eq("INSERT INTO people (name) VALUES ('Gregg'),('Bob');")
    end

    it 'does not quote numeric types' do
      insert.new_row do |r|
        r.age 27
      end

      expect(insert.to_sql).to eq("INSERT INTO people (age) VALUES (27);")
    end

    it 'treats hash objects as JSON' do
      insert.new_row do |r|
        r.raw({ name: 'Gregg' })
      end

      expect(insert.to_sql).to eq(%q[INSERT INTO people (raw) VALUES ($JSON${"name":"Gregg"}$JSON$);])
    end

    it 'treates nil values as NULL' do
      insert.new_row do |r|
        r.age nil
      end

      expect(insert.to_sql).to eq("INSERT INTO people (age) VALUES (NULL);")
    end

    it 'can insert multiple rows with different columns' do
      insert.new_row do |r|
        r.name 'Gregg'
      end

      insert.new_row do |r|
        r.age 27
      end

      expect(insert.to_sql).to eq("INSERT INTO people (name,age) VALUES ('Gregg',NULL),(NULL,27);")
    end
  end
end
