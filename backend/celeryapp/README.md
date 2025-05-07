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

## Installation

<lots of details missing ...>

- install ruby with your choice of version manager (I used rvm)
- bundle install
- rails db:migrate

**install redis**

```brew install redis```

[redis installation guide](https://redis.io/docs/latest/operate/oss_and_stack/install/archive/install-redis/install-redis-on-mac-os/)

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

### redis and sidekiq

**start redis**

```redis-server``` to run in terminal or to run in the background:
```brew services start redis```

[more redis start, stop, etc commands](https://redis.io/docs/latest/operate/oss_and_stack/install/archive/install-redis/install-redis-on-mac-os/)

**start sidekiq**

You will also need to start sidekiq.

```bundle exec sidekiq```

[sidekiq getting started guide](https://github.com/sidekiq/sidekiq/wiki/Getting-Started)
