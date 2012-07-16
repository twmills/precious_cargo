module PreciousCargo

  module Data
    class << self
      def encrypt!(data, options = {})
        secret = options.delete(:secret)

        cipher = OpenSSL::Cipher::AES.new(256, :CBC)
        cipher.encrypt
        cipher.key = secret
        Base64.encode64(cipher.update(data) + cipher.final)
      end

      def decrypt!(encrypted_data, options = {})
        secret = options.delete(:secret)
        encrypted_data = Base64.decode64(encrypted_data)

        decipher = OpenSSL::Cipher::AES.new(256, :CBC)
        decipher.decrypt
        decipher.key = secret
        decipher.update(encrypted_data) + decipher.final
      end
    end
  end

end