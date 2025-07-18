# README

## First time setup

Install rbenv/rvm/other to install ruby version ```3.2.2```

Install postgres

Install bundler and run ```bundle install```

...

```rails db:create```

```rails db:migrate```

Run with ```rails s```

Set resend api key
```export RESEND_API_KEY=<ask sarah>```

## Development

### DB

```rails db:migrate```

### Tests

To run all tests:
```rspec```

To run all api tests:
```rspec spec\requests```

To run a specific test case
```rspec spec/requests/users_spec.rb -e "adds tags"```

Clear test db
```bundle exec rails db:reset RAILS_ENV=test```

or

```
bundle exec rake db:drop RAILS_ENV=test
bundle exec rake db:create RAILS_ENV=test
bundle exec rake db:schema:load RAILS_ENV=test
```

### Rails

Add a new gem and
```bundle install```

### localhost

Open rails console to inspect or call anything in the rails app

```rails c```

**Seed data in localhost using factories**

Factories are defined in /spec/factories and are used for testing. To access factory bot create factories in rails c,

```shell

require 'factory_bot'
include FactoryBot::Syntax::Methods

```

