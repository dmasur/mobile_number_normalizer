# MobileNumberNormalizer
[![Build Status](https://secure.travis-ci.org/TBAA/mobile_number_normalizer.png?branch=master)](http://travis-ci.org/TBAA/mobile_number_normalizer)
[![Code Climate](https://codeclimate.com/badge.png)](https://codeclimate.com/github/TBAA/mobile_number_normalizer)

This Gem introduce a MobileNumberNormalizer. It normalize mobile phone numbers and was tested againt
many german and international mobile numbers.

Numbers without international area prefix will be prefixed with 0049 for germany.

Please take a look at the spec file for many examples.

## Installation

Add this line to your application's Gemfile:

    gem 'mobile_number_normalizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install mobile_number_normalizer

## Usage

MobileNumberNormalizer.get_number("01771234567")
# => "00491771234567"

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Added some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
