# README

This README would normally document whatever steps are necessary to get the
application up and running.

Things you may want to cover:

* Ruby version

* System dependencies

* Configuration

* Database creation

* Database initialization

* How to run the test suite

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

### DB

```rails db:migrate```

### Tests

```rspec```

```rspec spec\requests```

```rspec spec/requests/users_spec.rb -e "adds tags"```

Clear test db
```bundle exec rails db:reset RAILS_ENV=test```

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

