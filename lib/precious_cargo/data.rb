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
        cipher = Gibberish::AES.new(secret)
        cipher.encrypt(data)
      end

      # Public: Decrypt the supplied data using a secret string. Currently only supports AES 256 encryption.
      # data    - The data to be encrypted.
      # options - Hash of values used to encrypt the secret.
      #           :secret - A secret string.
      #
      # Returns the AES encrypted data.
      def decrypt!(encrypted_data, options = {})
        secret = options.delete(:secret)
        cipher = Gibberish::AES.new(secret)
        cipher.decrypt(encrypted_data).strip
      end
    end
  end

end