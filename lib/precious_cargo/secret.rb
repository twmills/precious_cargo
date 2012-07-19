module PreciousCargo

  # Public: A collection of methods to encrypt and decrypt the secret key used to encrypt the payload's data.
  module Secret
    class << self

      # Public: Encrypt the supplied secret string using an RSA public key object. If a secret is not supplied, then a
      # random secret is generated. It is generally better to randomly generate a secret every time you encrypt your
      # precious cargo.
      #
      # options - Hash of values used to encrypt the secret.
      #           :secret     - A secret string. If a secret string is not passed in, then one is randomly generated.
      #           :public_key - The RSA public key object used to encrypt the secret.
      #
      # Returns the RSA encrypted secret as a Base64 encoded string.
      def encrypt!(options = {})
        secret = options.delete(:secret) || Secret.random
        public_key = options.delete(:public_key)
        Base64.encode64(public_key.public_encrypt(secret))
      end

      # Public: Decrypt the supplied Base64 encoded secret string using an RSA key pair object.
      #
      # options - Hash of values used to decrypt the secret.
      #           :encrypted_secret - A Base64 encoded, RSA encrypted secret string.
      #           :keypair          - The RSA key pair object used to decrypt the secret.
      #
      # Returns the decrypted secret.
      def decrypt!(options = {})
        encrypted_secret = Base64.decode64(options.delete(:encrypted_secret))
        keypair = options.delete(:keypair)
        keypair.private_decrypt(encrypted_secret)
      end

      # Public: Generates a random 32 character string.
      #
      # Returns random 32 character string.
      def random
        Array.new(32){rand(36).to_s(36)}.join
      end
    end
  end

end