# FakeAWS

A minimal implementation of AWS as a Rack app, for testing and development.

This is designed to pair nicely with [AWSRaw](https://github.com/envato/awsraw).


## Installation

Add this line to your application's Gemfile:

    gem 'fake_aws'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install fake_aws


## Status [![Build Status](https://travis-ci.org/envato/fake_aws.png)](https://travis-ci.org/envato/fake_aws) [![Code Climate](https://codeclimate.com/github/envato/fake_aws.png)](https://codeclimate.com/github/envato/fake_aws)

This is still in the very early stages of development.

So far there's only a tiny bit of S3 implemented, but it's well tested and
fairly easy to extend. Pull requests for more features are welcome.

The S3 implementation only supports basic PUT Object and GET Object requests.
No authentication or security is implemented.  `Content-Type` and
`x-amz-metadata` headers are stored and returned.


## Usage

The easiest way to try this out is with [Faraday](https://github.com/lostisland/faraday):

```ruby
connection = Faraday.new do |faraday|
  faraday.adapter :rack, FakeAWS::S3::RackApp.new('root_directory')
end
```

The root directory you provide is used to store S3 objects and metadata.

For example, the following PUT Object request:

```ruby
connection.put do |request|
  request.url("http://s3.amazonaws.com/test_bucket/test_path/test_file.txt")
  request.headers["Content-Type"] = "text/plain"
  request.body = "Hello, world!"
end
```

will create a file `root_directory/test_bucket/test_path/test_file.txt`.

(Note: `root_directory/test_bucket` must already exist! As there's no
implementation of the Create Bucket operation yet, you'll need to make the
directory for the bucket yourself before doing a PUT Object.)

It will also create
`root_directory/test_bucket/test_path/test_file.txt.metadata.json`, which holds
the metadata for the file as a JSON hash.


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do

- Return user metadata on GET Object requests
- Handle PUT Object Copy requests
- Check signing of requests


