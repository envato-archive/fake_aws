# Headers that should exist in every S3 response.
shared_examples "common response headers" do
  it "has a Date header" do
    time = Time.parse("2013-11-18 17:45")
    allow(Time).to receive(:now).and_return(time)
    expect(subject.headers["Date"]).to eq(time.httpdate)
  end

  it "has a Server header" do
    expect(subject.headers["Server"]).to eq("AmazonS3")
  end

  it "has a request ID" do
    expect(subject.headers["x-amz-request-id"]).to_not be_blank
  end
end
