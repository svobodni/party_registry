require "digest/sha1"

module Devise
  module Encryptable
    module Encryptors
      # = DotnetSha1
      # Simulates Dotnet's default encryption mechanism.
      class DotnetSha1 < Base
        # Generates a default password digest based on salt, pepper and the
        # incoming password.
        def self.digest(password, stretches, salt, pepper)
          encode_password(password, salt)
        end

        def self.encode_password(password, salt)
          bytes = ""
          password.each_char { |c| bytes += c + "\x00" }
          salty = Base64.decode64(salt)
          concat = salty+bytes
          sha1 = Digest::SHA1.digest(concat)
          encoded = Base64.encode64(sha1).strip()
        end

      end
    end
  end
end