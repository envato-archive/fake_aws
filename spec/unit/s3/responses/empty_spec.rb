require 'spec_helper'

describe FakeAWS::S3::Responses::Empty do
  include_examples "common response headers"

  it "has a status code of 200" do
    expect(subject).to be_ok
  end

  it "has an empty body" do
    expect(subject.body).to be_empty
  end

end
