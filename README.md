# FakeAWS

A minimal implementation of AWS as a Rack app, for testing and development.

This is still in the very early stages of development.

So far there's only a tiny bit of S3 implemented, but it's well tested and
designed to be easy to extend. Pull requests for more features are welcome.

## Installation

Add this line to your application's Gemfile:

    gem 'fake_aws'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fake_aws

## Usage

TODO: Write usage instructions here

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do

- Split up the rack app tests into separate files for the different operations
- Handle bucket names in the host as well as the path
- Spit out a properly formatted response on a successful PUT object operation
- Complete the missing fields in XML error responses
- Check signing of requests
- Handle PUT Object copy requests
