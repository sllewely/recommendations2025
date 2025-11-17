# README

## First time setup

Install rbenv/rvm/other to install ruby version ```3.2.2```

---

rbenv can be installed by homebrew and requires rbenv init & updating the path to work

frequent problem [stackoverflow: rbenv not updating local ruby version](https://stackoverflow.com/questions/10940736/rbenv-not-changing-ruby-version)
- run rbenv init
- confirm zshrc has it in the path, if that's the shell you're using

---

Install postgres

```
brew install postgresql@14
```

```
brew services start postgresql@14
```

---

Install bundler and run ```bundle install```

If you're getting "rails not installed error at this stage, open a new terminal.


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


### Troubleshooting

**install openssl*

```gem install openssl -- --with-openssl-dir=$(brew --prefix openssl@3)```


