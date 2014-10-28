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
          pass_a = password.encode("UTF-16LE").bytes.to_a
          salt_a = Base64.decode64(salt).force_encoding("utf-8").bytes.to_a
          sha1 = Digest::SHA1.digest((salt_a+pass_a).pack('C*'))
          encoded = Base64.encode64(sha1).strip()
        end

      end
    end
  end
end