# Headers that should exist in every S3 response.
shared_examples "common response headers" do
  it "has a Date header" do
    time = Time.parse("2013-11-18 17:45")
    Time.stub(:now => time)
    expect(subject.headers["Date"]).to eq(time.httpdate)
  end

  it "has a Server header" do
    expect(subject.headers["Server"]).to eq("AmazonS3")
  end

  it "has request ID headers"
end
