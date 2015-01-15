require 'spec_helper'

describe FakeAWS::S3::Responses::Empty do
  include_examples "common response headers"

  it "has a status code of 200" do
    expect(subject.status_code).to eq(200)
  end

  it "has an empty body" do
    expect(subject.body).to eq([''])
  end

end
