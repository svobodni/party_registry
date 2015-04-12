# -*- encoding : utf-8 -*-

require 'test_helper'

class PersonTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  should "validate encrypted passwords" do
    sha = Devise::Encryptable::Encryptors::DotnetSha1.encode_password("abcd1234","DI79ye8wZNDKPOxAwZr1iA==")
    assert_equal "+3fb2VTdvk+NmmDzHO87Yip7New=", sha
  end

  should "validate czech encrypted passwords" do
    sha = Devise::Encryptable::Encryptors::DotnetSha1.encode_password("žluťoučkýkůň","DI79ye8wZNDKPOxAwZr1iA==")
    assert_equal "K8+Y0RM8lIXWJRk1dAvkxA7gC+0=", sha
  end

end
