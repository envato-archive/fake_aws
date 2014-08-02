require 'spec_helper'

describe "An unsupported ooperation" do
  include S3IntegrationHelpers

  it "raises an unsupported request exception" do
    expect {
      connection.delete("/")
    }.to raise_error(FakeAWS::UnsupportedRequestError)
  end
end

