require 'test_helper'

class AuthControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    @public_key = "-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALsl3zoyj4QoyIzxEOZ/o/xQ3nuJRBJd\nhMNC+5LXdlhKbfp42/px6xQk0G86+vQasoiJ51l/2IAzOA5FEFf1MVsCAwEAAQ==\n-----END PUBLIC KEY-----\n"
  end

  test "should get public_key" do
    get :public_key, format: :json
    assert_response :success
    assert_equal @public_key, response.body
  end

  test "should get token with valid signature" do
    sign_in people(:mach)
    get :token, format: :json
    assert_response :success
    public_key = OpenSSL::PKey::RSA.new(@public_key)
    JWT.decode(response.body, public_key)
  end

  test "should get token with proper content" do
    sign_in people(:mach)
    get :token, format: :json
    assert_response :success
    jwt = JWT.decode(response.body, nil, nil).first
    assert_equal "db|#{people(:mach).id}", jwt['sub']
  end

  test "should get profile using proper token" do
    @request.headers["Auth"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL3JlZ2lzdHIuc3ZvYm9kbmkuY3oiLCJzdWIiOiJkYnw3NDg5NzgzOTciLCJuYmYiOjE0MDM0MzAxMDgsImV4cCI6MTQwMzQzMzcwOCwiaWF0IjoxNDAzNDMwMTA4LCJqdGkiOiIwNzlhMTE4Mi0wNzQzLTRkYWYtOWZhYi0wODc0YzcyZjk3YzIiLCJ0eXAiOiJodHRwczovL3JlZ2lzdHIuc3ZvYm9kbmkuY3ovYXV0aCJ9.NYWFx9UwIkKSa-5D6c1l1q-s5A7R_ns5eJA4grrOYRWY_Ne9BvoNvTGVlUXa1_oU1qygSUCWQHWofp0exgF_9w"
    get :profile, format: :json
    assert_response :success
    person = JSON.parse(response.body)['person']
    assert_equal "mach@svobodni.cz", person['email']
    assert_equal "President", person['roles'].first['name']
  end

end
