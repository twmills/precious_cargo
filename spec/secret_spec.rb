require "spec_helper"

describe PreciousCargo::Secret do

  before do
    @keypair = OpenSSL::PKey::RSA.new(2048)
    @public_key = @keypair.public_key
    @secret = "Secret secret, I've got a secret.'"
  end

  context "#encrypt!" do
    it "encrypts a secret using the supplied public key" do
      options = {}
      options[:secret] = @secret
      options[:public_key] = @public_key
      encrypted_secret = subject.encrypt!(options)
      @keypair.private_decrypt(encrypted_secret).should == @secret
    end

    it "generates and encrypts a random secret using the supplied public key" do
      options = {}
      options[:public_key] = @public_key
      encrypted_secret = subject.encrypt!(options)
      @keypair.private_decrypt(encrypted_secret).length.should == 32
    end
  end

  context "#decrypt!" do
    it "decrypts a secret using the supplied keypair" do
      options = {}
      options[:encrypted_secret] = @public_key.public_encrypt(@secret)
      options[:keypair] = @keypair
      subject.decrypt!(options).should == @secret
    end
  end

  context "#random" do
    it "generates a random string" do
      subject.random.should_not == subject.random
    end

    it "generates a random string 32 characters long" do
      subject.random.length.should == 32
    end
  end

end