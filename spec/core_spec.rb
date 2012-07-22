require "spec_helper"

describe PreciousCargo, "#encrypt!" do

  before do
    @keypair = OpenSSL::PKey::RSA.new(2048)
    @data = Faker::Lorem.paragraphs.join(" ")
    @secret = "password"
  end

  it "encrypts and decrypts data with an auto-generated secret" do
    payload = subject.encrypt!(@data, :public_key => @keypair.public_key)
    unencrypted_data = subject.decrypt!(payload.delete(:encrypted_data), payload.merge(:keypair => @keypair))
    unencrypted_data.should == @data
  end

  it "encrypts and decrypts data with supplied secret" do
    payload = subject.encrypt!(@data, :public_key => @keypair.public_key)
    unencrypted_data = subject.decrypt!(payload.delete(:encrypted_data), payload.merge(:keypair => @keypair))
    unencrypted_data.should == @data
  end

end