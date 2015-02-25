# InsertInto

Simple DSL for building SQL INSERT statements.  It was born out of a desire to
insert a large amount of data without the baggage of an ORM.  ActiveRecord
doesn't support multi-row inserts and wraps each insert in a transaction.  This
results in a signifant performance hit compared to inserting mutiple rows in
one transaction.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'insert-into', require: 'insert_into'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install insert-into

## Usage

The simplest case is inserting one row into a table `people` that has a column
named `name`:

```ruby
insert = InsertInto::Statement.new('people')

insert.new_row do |r|
  r.name 'Gregg'
end

insert.to_sql
#> "INSERT INTO people (name) VALUES ('Gregg');"
```

`InsertInto` doesn't provide a means of executing the statement, so it should
be paired with a database adapter library to execute the statement:

```ruby
ActiveRecord::Base.execute(insert.to_sql)
```

The best way to use this library is for inserting multiple rows:

```ruby
insert = InsertInto::Statement.new('people')

people_attributes.each do |person|  # where `people_attributes` is an array of attribute hashes
  insert.new_row do |r|
    r.name person[:name]
  end
end
```

Note that the input values are not sanitized, so user input should not be
directly passed here.  If you'd like to specify the return columns, you can do so
using `returning`:

```ruby
insert = InsertInto::Statement.new('people')

insert.new_row do |r|
  r.name 'Gregg'
end

insert.returning('name')

insert.to_sql
#> "INSERT INTO people (name) VALUES ('Gregg') RETURNING name;"
```

## Contributing

1. Fork it (https://github.com/bluebottlecoffee/insert_into)
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
