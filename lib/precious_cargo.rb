require "gibberish"
require "precious_cargo/version"
require 'precious_cargo/secret'
require 'precious_cargo/data'

# Public: PreciousCargo encapsulates a specific best practice when encrypting large (or small) amounts of data, normally
# to transmit over the wire via a web service.
#
# PK encryption is typically the preferred encryption method, but it suffers from the limitation that the size of data
# being encrypted cannot exceed the key size. To get around this approach, yet still take advantage of the excellent
# encryption method, the data is first encrypted with AES encryption using a secret passphrase. The secret passphrase is
# then encrypted using the public key from an RSA keychain and both the encrypted secret and encrypted data are sent
# together as part of the same payload to the client.
#
# The client decrypts the encrypted secret with their private key from the RSA key pair, then uses the decrypted
# secret to decrypt the AES encrypted data.
#
# The PreciousCargo module, therefore, provides convenience methods to encapsulate these multi-step encryption and
# decryption processes. Though it is possible to use a "shared secret" to encrypt the data, for extra security the
# encrypt method will generate a random secret passphrase if one is not explicitly provided.
#
# Examples:
#
# @data = "This is my precious cargo."
# @keypair = OpenSSL::PKey::RSA.new(2048)
#
# With an auto-generated secret (the preferred method):
# @encrypted_payload = PreciousCargo.encrypt!(@data, :public_key => @keypair.public_key)
# #=> { :encrypted_data => [Base64 encoded string of encrypted data], :encrypted_secret => [Base64 encoded string of the encrypted secret] }
#
# PreciousCargo.decrypt!([Base64 encoded string of encrypted data], :keypair => @keypair, :encrypted_secret => [Base64 encoded string of the encrypted secret])
# #=> "This is my precious cargo."
#
# With a supplied secret:
# @encrypted_payload = PreciousCargo.encrypt!(@data, :secret => 'p@assw0rD', :public_key => @keypair.public_key)
# #=> {:encrypted_data => [Base64 encoded string of encrypted data], :encrypted_secret => [Base64 encoded string of the encrypted secret]}
#
# PreciousCargo.decrypt!([Base64 encoded string of encrypted data], :keypair => @keypair, :encrypted_secret => [Base64 encoded string of the encrypted secret])
# #=> "This is my precious cargo."
#
module PreciousCargo

  class << self

    # Public: Encrypt the supplied data using ASES encryption with a secret pass phrase. The secret will also be
    # encrypted using an RSA public key object. If a secret is not supplied, then a random secret is generated. It is
    # generally better to randomly generate a secret every time you encrypt your precious cargo.
    #
    # data    - The data to be encrypted.
    # options - Hash of values used to encrypt the data.
    #           :secret     - Optional. A secret string. If a secret string is not passed in, then one is randomly
    #                         generated.
    #           :public_key - The RSA public key object used to encrypt the secret.
    #
    # Returns a hash containing the Base64 encoded encrypted data and Base64 encoded encrypted secret.
    def encrypt!(data, options = {})
      options[:secret]  = PreciousCargo::Secret.random unless options.has_key?(:secret)
      encrypted_data    = PreciousCargo::Data.encrypt!(data, options)
      encrypted_secret  = PreciousCargo::Secret.encrypt!(options)
      { :encrypted_secret => encrypted_secret, :encrypted_data => encrypted_data }
    end

    # Public: Decrypt the supplied Base64 encoded encrypted data using the supplied Base64 encoded encrypted secret. The
    # secret is first decrypted using the supplied RSA key pair object and is then used to decrypt the AES encrypted
    # data. Optionally if the secret is known and shared, it can be supplied in lieu of the encrypted secret (though it
    # rather defeats the purpose of this gem and may be removed at a later date).
    #
    # options - Hash of values used to decrypt the secret.
    #           :encrypted_secret - A Base64 encoded, RSA encrypted secret string.
    #           :keypair          - The RSA key pair object used to decrypt the secret.
    #           :secret           - Optional. A plaintext shared secret.
    #
    # Returns the decrypted secret.
    def decrypt!(data, options = {})
      unless options.has_key?(:secret)
        options[:secret] = PreciousCargo::Secret.decrypt!(options)
      end

      PreciousCargo::Data.decrypt!(data, options)
    end
  end

end
