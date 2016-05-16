# Dashi

Turns a Sauce Labs session into an executable test

## Installation

Most important step: Promise you won't judge me for my awful code.

Clone this repo, DylanLacey/bonito and DylanLacey/konbu.

Update the `:path` for bonito and konbu in this repo's Gemfile
Update the `:path` for konbu in bonito's Gemfile

Run `bundle install` in this gem's directory.

## Usage

`bundle exec dashi session_id filename`

## Fun and Exciting Known Bugs
* Only works for desktop platforms
* Does not know how to give elements unique names or refer to new elements (This is being worked on in a branch but is a hideous mess)
* Only knows how to create a session, open a webpage, find an element or quit.  Concept: The proof of it.

## Future Features
* DSL for new languages
* Ability to construct slightly more complex language ... constructs, like Spin Asserts & fluent operations:
  `driver.find_element(:id, 'rad_button').click
* Mobile platforms
* Spiders!
