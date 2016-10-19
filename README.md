# Dashi

Turns a Sauce Labs session into an executable test.  _Kinda_ supports multiple languages with the inclusion of a simple set of formatters.

Fun stuff this _might_ be able to do:  Improve the tests it's given.  `bonito`, one of the sub-libraries, can run rules across a set of Selenium Commands and produce new ones instead.  This will let it "guess" if a customer has done something like added a spin assert... But we could also cut out needless duplicates, or window resizing that achieves nothing, or correct their desired capabilities...

## Installation

Most important step: Promise you won't judge me for my awful code.

Clone this repo, and check you can access DylanLacey/bonito and DylanLacey/konbu.

Run `bundle install` in this gem's directory.

## Usage

`bundle exec dashi session_id filename`

## How to generate a compatible test
`cd test_test`
`bundle install`
`bundle exec ruby repro.rb`

Copy the job ID output to the console, `cd` back to the root directory and 

`bundle exec dashi session_id filename.rb`

You can then run the test again with

`bundle exec ruby filename.rb

## What is it made of?

`konbu` turns the Sauce.log into a stream of, effectively, Selenium tokens
`bonito` classifies those tokens into a command hierachy; ElementInteractionCommands include locators, value setters and getters.  `bonito` can also apply parse & lint rules to tests but for this purpose it's just classifying.  It does construct an element table which it returns along with the command list.

`dashi` is fetching the Sauce Log which is eventually passed to `konbu`, then consuming the classified commands and passing them, one by one, to the relevant formatting class (one for each command).

Each of these classes is based on an abstract implementation which knows how to get the details it needs from the Command; The concrete implementations are for a specific language and know how to format for that language.  This is the worst bit currently;  I think there should be one formatter that `include`s a language's patterns at runtime.  Ideally, we could generate patterns through *wave**sparkles**sparkling_heart*_metaprogramming**sparkles**sparkling_heart**wave*.

Once the commands are formatter, they're passed to a test shell template that does all the required library inclusions.  Rather then string contatenation, this is done using ERB, the built in Ruby formatting engine.  I think it'd be best to redo the above by having each individual command render with ERB, in part because it makes the metaprogramming easier.

## Fun and Exciting Known Bugs
* Only works for desktop platforms
* Some platforms are named incorrectly
* Only works for finding, `send_keys`, clearing, booting and quitting a session. Concept: The proof of it.
* *BONUS* Clicking!
* Gives elements random names!

## Future Features
* DSL for new languages
* Other Commands!
* Ability to construct slightly more complex language constructs, like Spin Asserts & fluent operations:
  `driver.find_element(:id, 'rad_button').click
* Mobile platforms
* Spiders!  :spider:
