# Dashi

Turns a Sauce Labs session into an executable test

## Installation

Most important step: Promise you won't judge me for my awful code.

Clone this repo, and check you can access DylanLacey/bonito and DylanLacey/konbu.

Run `bundle install` in this gem's directory.

## Usage

`bundle exec dashi session_id filename`

## Fun and Exciting Known Bugs
* Only works for desktop platforms
* Only works for finding, `send_keys`, booting and quitting a session. Concept: The proof of it.
* Gives elements random names!

## Future Features
* DSL for new languages
* Ability to construct slightly more complex language constructs, like Spin Asserts & fluent operations:
  `driver.find_element(:id, 'rad_button').click
* Mobile platforms
* Spiders!  :spider:
