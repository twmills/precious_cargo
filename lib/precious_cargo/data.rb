module PreciousCargo

  # Public: A collection of methods to encrypt and decrypt data using
  # a supplied secret.
  module Data
    class << self

      # Public: Encrypt the supplied data using a secret string. Currently only supports AES 256 encryption.
      # data    - The data to be encrypted.
      # options - Hash of values used to encrypt the secret.
      #           :secret - A secret string.
      #
      # Returns the AES encrypted data.
      def encrypt!(data, options = {})
        secret = options.delete(:secret)

        cipher = OpenSSL::Cipher::AES.new(256, :CBC)
        cipher.encrypt
        cipher.key = secret
        Base64.encode64(cipher.update(data) + cipher.final)
      end

      # Public: Decrypt the supplied data using a secret string. Currently only supports AES 256 encryption.
      # data    - The data to be encrypted.
      # options - Hash of values used to encrypt the secret.
      #           :secret - A secret string.
      #
      # Returns the AES encrypted data.
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