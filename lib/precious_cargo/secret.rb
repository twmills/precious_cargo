module PreciousCargo

  module Secret
    class << self
      def encrypt!(options = {})
        secret = options.delete(:secret) || Secret.random
        public_key = options.delete(:public_key)
        public_key.public_encrypt(secret)
      end

      def decrypt!(options = {})
        encrypted_secret = options.delete(:encrypted_secret)
        keypair = options.delete(:keypair)
        keypair.private_decrypt(encrypted_secret)
      end

      def random
        Array.new(32){rand(36).to_s(36)}.join
      end
    end
  end

end