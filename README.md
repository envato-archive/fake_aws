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

So far there's only a tiny bit of S3 implemented, but it's well tested and
fairly easy to extend. Pull requests for more features are welcome.


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

It will also create
`root_directory/test_bucket/test_path/test_file.txt.metadata.json`, which holds
the metadata for the file as a JSON hash.

## Rake tasks

Run `fake_aws:nuke` to delete all files inside the Fake AWS root directory.

## Implemented Operations

### S3

Path-style, virtual-hosted-style, and CNAME-style requests are supported for
all operations.

No authentication or security is implemented.

`Content-Type` and `x-amz-metadata` headers are stored and returned.

- [GET Object](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectGET.html)
- [PUT Bucket](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketPUT.html)
- [PUT Object](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTObjectPUT.html)

Pull requests for other operations are welcome!


## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## To Do

- Implement [GET Bucket](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTBucketGET.html) requests
- Improve the [response headers](http://docs.aws.amazon.com/AmazonS3/latest/API/RESTCommonResponseHeaders.html) (Content-Length, ETag, etc.)
- Check signing of requests
- Handle PUT Object Copy requests


