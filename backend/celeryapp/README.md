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

```bundle exec rspec```

```bundle exec rspec spec\requests```

Clear test db
```bundle exec rails db:reset RAILS_ENV=test```

### Rails

Add a new gem and
```bundle install```

## First time setup


### ruby version

If you have homebrew

---

Install with rvm

You will need to get the same ruby version.  Install **rvm** with [these instructions](https://rvm.io/rvm/install)

If you encounter errors try [install rvm for macOS](https://jeffreymorgan.io/articles/ruby-on-macos-with-rvm/)

---

Install with rbenv instead!! Seems much simpler

```brew install rbenv```

```rbenv install 3.2.2```

```rbenv global 3.2.2```

Relevant [stackoverflow for installing ruby version](https://superuser.com/questions/340490/how-to-install-and-use-different-versions-of-ruby).

---

### Set up database

Install postgres with the instructions I have in this repo [first time setup](https://superuser.com/questions/340490/how-to-install-and-use-different-versions-of-ruby)


Or use docker.  Should put whole project in docker

```brew install docker```

---


```gem install bundler```

```brew install bundler```


