# Slahub

Welcome to your new gem! In this directory, you'll find the files you need to be able to package up your Ruby library into a gem. Put your Ruby code in the file `lib/slahub`. To experiment with that code, run `bin/console` for an interactive prompt.

TODO: Delete this and the text above, and describe your gem

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'slahub'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install slahub

### Setup database

* user: postgres
* host: localhost
* database: slahub

First, create the database.

```bash
$ echo 'CREATE DATABASE slahub' | psql -U postgres -h localhost
```

Then, apply the schema to the created database.

```bash
# dry-run
$ bundle exec ridgepole --file schema/Schemafile --config='postgres://postgres:@localhost:5432/slahub?encoding=utf8' --apply --dry-run
# apply
$ bundle exec ridgepole --file schema/Schemafile --config='postgres://postgres:@localhost:5432/slahub?encoding=utf8' --apply
```

## Usage

TODO: Write usage instructions here

## Development

After checking out the repo, run `bin/setup` to install dependencies. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/pocke/slahub.

