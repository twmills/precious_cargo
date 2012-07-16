require "spec_helper"

describe PreciousCargo::Data do

  before do
    @keypair = OpenSSL::PKey::RSA.new(2048)
    @data = Faker::Lorem.paragraphs.join(" ")
    @secret = "Secret secret, I've got a secret."
  end

  context "#encrypt!" do
    it "encrypts data using the supplied secret" do
      options = {}
      options[:secret] = @secret
      encrypted_data = subject.encrypt!(@data, options)

      options[:secret] = @secret
      decrypted_data = subject.decrypt!(encrypted_data, options)

      decrypted_data.should == @data
    end
  end

  context "#decrypt!" do
    it "decrypts a secret using the supplied secret" do
      options = {}
      options[:secret] = @secret
      encrypted_data = subject.encrypt!(@data, options)

      options[:secret] = @secret
      subject.decrypt!(encrypted_data, options).should == @data
    end
  end

end