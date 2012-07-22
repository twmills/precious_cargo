require "spec_helper"

describe PreciousCargo::Data do

  before do
    @keypair = OpenSSL::PKey::RSA.new(2048)
    @data = Faker::Lorem.paragraphs.join(" ")
    @secret = "password"
  end

  context "#encrypt!" do
    it "encrypts data using the supplied secret" do
      encrypted_data = subject.encrypt!(@data, :secret => @secret)
      from_openssl = `echo "#{encrypted_data}" | openssl enc -d -aes-256-cbc -a -k password`
      from_openssl.should == @data
    end
  end

  context "#decrypt!" do
    it "decrypts a secret using the supplied secret" do
      from_openssl = `echo #{@data} | openssl enc -aes-256-cbc -a -k password`
      subject.decrypt!(from_openssl, :secret => @secret).should == @data
    end
  end

end