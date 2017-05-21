# Aurora iOS App

This app connects to an Aurora Server instance ([see this project](https://github.com/barrymcandrews/aurora-server)) to control the color or pattern of an RGB LED strip. You can choose from a pool of existing colors and patterns or use the editor to make your own.

## Getting Started

### Prerequisities

This project uses Carthage as a dependency manager. If you do not have Carthage already installed you can do so using macOS Homebrew:

```
$ brew update
$ brew install carthage
``` 

### Installation

To use and contribute to this project clone it directly from this repository:

```
#HTTP
$ git clone https://github.com/theAlexPatin/MMiOS.git
#SSH
$ git clone git@github.com:theAlexPatin/MMiOS.git
```
####Dependencies

Before building the project you must download all dependencies with Carthage. In your terminal, navigate to the root of the project directory and run the following command:

```
$ carthage update --platform iOS
```

Unfortunately, in order to get the animations from the [Hero](https://github.com/lkzhao/Hero/) library to work correctly, I was forced to edit the source code and publicly expose one method. Hopefully, they'll fix this in the future, but in the meantime you'll have to make this change to get the code to work. 

On line 295 of Hero.swift change `private extension Hero` to `public extension Hero`
