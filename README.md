# Wishlist

[![Build Status](https://travis-ci.org/alexlafroscia/wishlist.svg?branch=master)](https://travis-ci.org/alexlafroscia/wishlist)

> Ruby on Rails and Ember.js application for making wishlists and sharing them with friends and family

## Installing Dependencies

Since we're using both Ruby on Rails and Ember.js for this project, both of their dependencies need to be installed.  You can do that with the following commands:

```bash
bundle install
cd frontend
npm install
```

This may take a little time, but will get everything set up and ready to go.

## Running the Application

Thanks to the [ember-cli-rails][Ember CLI Rails] gem, you don't have to touch the Ember server at all; all that's required is for you to run the Rails server as you normally would, like so:

```bash
rails server
```

## Running the Tests

Since this application contains both a Rails app and an Ember app, they each have tests that should be run.  While the tests will always be run on Travis CI, it's always good to run them locally, too.

### Rails Tests

```bash
rake test
```

### Ember Tests

Run the Ember tests from the `frontend` directory, like so:

```
cd frontend
ember test
```


[Ember CLI Rails]: https://github.com/thoughtbot/ember-cli-rails "Ember CLI Rails Gem"
