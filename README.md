# EVOlution - iOS

The goal of this project is for the version 1.0 was: bring to iOS the experience provided by Swift Evolution [website](https://apple.github.io/swift-evolution).

Now we are shifting from the basic idea to make it more social. 

On our roadmap (you can read at our [GitHub Projects](https://github.com/Evolution-App/iOS/projects/2)), we have some notes for the future, which will cover stuff like: Follow Proposals starring or watching them, Follow Authors and/or Review Managers, List of most popular proposals, featured proposals and other ideas coming from the community.

![](images/screenshots_base.png)

## Environment prerequisites

### Ruby

If you don't have experience with Ruby we recommend [rbenv](https://github.com/rbenv/rbenv):

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
rake xcode:tests
```

## How to contribute

You need to create an issue and associate a pull request to this issue. Your pull request, needs to have some description on title about the issue that you are trying to solve. 
After you send your pull request, other developers will make a code review before merging it into the _development_ branch.


## Author

- Thiago Holanda - [GitHub](https://github.com/unnamedd) / [Twitter](https://twitter.com/tholanda)


## Contributors 

- Anton Kuzmin - [GitHub](https://github.com/uuttff8) / [Twitter](https://twitter.com/babnikbezbab)
- Bruno Bilescky - [GitHub](https://github.com/brunogb) / [Twitter](https://twitter.com/bgondim)
- Bruno Guidolim - [GitHub](https://github.com/bguidolim) / [Twitter](https://twitter.com/bguidolim)
- Bruno Hecktheuer - [GitHub](https://github.com/bbheck) / [Twitter](https://twitter.com/brunobheck)
- Diego Ventura - [GitHub](https://github.com/diegoventura) / [Twitter](https://twitter.com/venturadiego)
- Diogo Tridapalli - [GitHub](https://github.com/diogot) / [Twitter](https://twitter.com/diogot)
- Gustavo Barbosa - [GitHub](https://github.com/barbosa) / [Twitter](https://twitter.com/gustavocsb)
- Guilherme Rambo - [GitHub](https://github.com/insidegui) / [Twitter](https://twitter.com/insidegui)
- Leonardo Cardoso - [GitHub](https://github.com/leonardocardoso) / [Twitter](https://twitter.com/leocardz)
- Ricardo Borelli - [GitHub](https://github.com/rabc) / [Twitter](https://twitter.com/rabc)
- Rob Hudson - [GitHub](https://github.com/robtimp) / [Twitter](https://twitter.com/robtimp)
- Rodrigo Reis - [GitHub](https://github.com/digoreis) / [Twitter](https://twitter.com/digoreis)
- Xaver Lohmüller - [GitHub](https://github.com/xaverlohmueller) / [Twitter](https://twitter.com/binaryXML)


## License

**EVOlution App** is available under the MIT license. See the LICENSE file for more info. 



---
<a href="https://www.buymeacoffee.com/tholanda"><img src="https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png" alt="Buy Me A Coffee" style="height: 41px !important;width: 174px !important;box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;-webkit-box-shadow: 0px 3px 2px 0px rgba(190, 190, 190, 0.5) !important;" target="_blank"></a>
