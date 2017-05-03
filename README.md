# Swift Evolution - iOS

The main goal of this project is to recreate as an iOS app, the web page created to [Swift Evolution](https://apple.github.io/swift-evolution).
At this moment, we do not have any layout so then, use the screenshots from webpage we will.

![](images/screenshots_base.png)

## Environment prerequisites

### Ruby

If yon don't have experience with Ruby we recommend [rbenv](https://github.com/rbenv/rbenv):

```sh
brew install rbenv
rbenv init
echo 'eval "$(rbenv init -)"' >> ~/.bash_profile
```

Install the Ruby version used on the project:

```sh
rbenv install `cat .ruby-version`
```

### Bundler

```sh
gem install bundler
```

### Optional: Rakefile auto complete

Nobody likes to type 😉

Brew has a [repository](https://github.com/Homebrew/homebrew-completions) only for auto completions:

```sh
brew tap homebrew/completions
brew install bash-completion
brew install rake-completion
```

Don't forget to add to your `.bash_profile`:

```sh
if [ -f $(brew --prefix)/etc/bash_completion ]; then
    . $(brew --prefix)/etc/bash_completion
fi
```

## Setup project

```sh
rake setup
```

## Running the tests

```sh
rake unit_tests
```

## How to contribute

You need to create an issue and associate a pull request to this issue.
After send your pull request, other developers will make a code review before merge into _development_ branch.


## Authors

- Thiago Holanda - [GitHub](https://github.com/unnamedd) / [Twitter](https://twitter.com/tholanda)
- Bruno Bilescky - [GitHub](https://github.com/brunogb) / [Twitter](https://twitter.com/bgondim)

## Contributors 

- Bruno Guidolim - [Github](https://github.com/bguidolim) / [Twitter](https://twitter.com/bguidolim)
- Bruno Hecktheuer - [Github](https://github.com/bbheck) / [Twitter](https://twitter.com/brunobheck)
- Diego Ventura - [GitHub](https://github.com/diegoventura) / [Twitter](https://twitter.com/venturadiego)
- Diogo Tridapalli - [Github](https://github.com/diogot) / [Twitter](https://twitter.com/diogot)
- Gustavo Barbosa - [Github](https://github.com/barbosa) / [Twitter](https://twitter.com/gustavocsb)
- Ricardo Borelli - [Github](https://github.com/rabc) / [Twitter](https://twitter.com/rabc)
- Rodrigo Reis - [Github](https://github.com/digoreis) / [Twitter](https://twitter.com/digoreis)

## License

**Swift Evolution** is available under the MIT license. See the LICENSE file for more info. 
