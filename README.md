# PreciousCargo

Secure large (or small) amounts of data for transfer over web services

### What is it?

PreciousCargo encapsulates a specific best practice when encrypting large (or small) amounts of data, normally to transmit over the wire via a web service. The strategy is not really complex, but it wasn't readily apparent when I was looking for a solution. Therefore I wrote this gem to make it convenient to not only apply this strategy, but to also make this best practice more easily discovered (hopefully).

### The Problem Case

PK encryption is typically the preferred encryption method, but it suffers from the limitation that the size of data being encrypted cannot exceed the key size. To get around this approach, yet still take advantage of the excellent encryption method, the data is first encrypted with AES encryption using a secret passphrase. The secret passphrase is then encrypted using the public key from an RSA keychain and both the encrypted secret and encrypted data are sent together as part of the same payload to the client.

The client then uses their private key from the RSA key pair to decrypt the encrypted secret, then use the decrypted secret to decrypt the AES encrypted data.

The PreciousCargo module, therefore, provides convenience methods to encapsulate these multi-step encryption and decryption processes. Though it is possible to use a "shared secret" to encrypt the data, for extra security the encrypt method will generate a random secret passphrase if one is not explicitly provided.

## Installation

    gem install precious_cargo

## Examples

```ruby
@data = "This is my precious cargo."
@keypair = OpenSSL::PKey::RSA.new(2048)

@payload = PreciousCargo.encrypt!(@data, { :public_key => @keypair.public_key })
#=> { :encrypted_secret => , :encrypted_data => }

PreciousCargo.decrypt!(@data, { :secret => , :private_key => @keypair.public_key })
#=> "This is my precious cargo."

@payload = PreciousCargo.encrypt!(@data, { :secret => 'p@assw0rD', :public_key => @keypair.public_key })
#=> { :encrypted_data => }

PreciousCargo.decrypt!(@data, { :encrypted_secret => , :keypair => @keypair })
#=> "This is my precious cargo."
```

## Dependencies

* Ruby compiled with OpenSSL support.
* The [gibberish gem](https://github.com/mdp/gibberish/).

## How to run the tests

    git clone https://github.com/twmills/precious_cargo.git
    cd precious_cargo
    bundle install
    rspec