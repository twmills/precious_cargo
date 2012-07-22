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
# The client then uses their private key from the RSA key pair to decrypt the encrypted secret, then use the decrypted
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
# @encrypted_payload = PreciousCargo.encrypt!(@data, { :public_key => @keypair.public_key })
# #=> { :encrypted_secret => , :encrypted_data => }
#
# PreciousCargo.decrypt!(@data, { :secret => , :private_key => @keypair.public_key })
# #=> "This is my precious cargo."
#
# @encrypted_payload = PreciousCargo.encrypt!(@data, { :secret => 'p@assw0rD', :public_key => @keypair.public_key })
# #=> { :encrypted_data => }
#
# PreciousCargo.decrypt!(@data, { :encrypted_secret => , :keypair => @keypair })
# #=> "This is my precious cargo."
#
module PreciousCargo

  class << self


    def encrypt!(data, options = {})
      options[:secret]  = PreciousCargo::Secret.random unless options.has_key?(:secret)
      encrypted_data    = PreciousCargo::Data.encrypt!(data, options)
      encrypted_secret  = PreciousCargo::Secret.encrypt!(options)
      { :encrypted_secret => encrypted_secret, :encrypted_data => encrypted_data }
    end

    def decrypt!(data, options = {})
      unless options.has_key?(:secret)
        options[:secret] = PreciousCargo::Secret.decrypt!(options)
      end

      PreciousCargo::Data.decrypt!(data, options)
    end
  end

end
