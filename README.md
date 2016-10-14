# danger-missed_localizable_strings

[![Build Status](https://travis-ci.org/Antondomashnev/danger-missed_localizable_strings.svg?branch=master)](https://travis-ci.org/Antondomashnev/danger-missed_localizable_strings)

Don't let developers to forget about the app localization.
Allow [Danger](https://github.com/danger/danger) to check whether there are
missing keys in any of modified or added .strings files in the PR.

## Important

Since [Danger](https://github.com/danger/danger) is developed in mind
to check only PR's. It won't help you if there is
already mis-synchronization of `Localizable.strings`.
To let the plugin do it's job, please update
project's `Localizable.strings` to contain all keys in each file.

## Installation

```sh
$ gem install danger-missed_localizable_strings
```

## Usage

Methods and attributes from this plugin are available in
your `Dangerfile` under the `missed_localizable_strings` namespace.
And that's it, there are no additional parameters currently =)

## Development

1. Clone this repo
2. Run `bundle install` to setup dependencies.
3. Run `bundle exec rake spec` to run the tests.
4. Use `bundle exec guard` to automatically have tests run as you make changes.
5. Make your changes.

## LICENSE

```
Copyright (c) 2016 Anton Domashnev

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
```
