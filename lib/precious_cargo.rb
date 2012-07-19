require "gibberish"
require "precious_cargo/version"
require 'precious_cargo/secret'
require 'precious_cargo/data'

module PreciousCargo

  class << self
    def encrypt!(data, options = {})
      payload = {}
      payload[:data] = self.encrypt_data!(data, options)
      payload[:secret] = ::Secret.encrypt!(options)
      payload
    end

    def decrypt!(data, options = {})

    end
  end

end
