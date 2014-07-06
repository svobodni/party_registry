# encoding: utf-8
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

  test "should be redirected with token added" do
    sign_in people(:mach)
    get :token, redirect_uri: 'https://somesystem.cz/callback.php', format: :html
    assert_response :redirect
    uri = URI.parse(response.redirect_url)
    assert_equal 'somesystem.cz', uri.host
    assert_equal '/callback.php', uri.path
    token = uri.query.split('&').collect{|kv| kv.split('=')}.to_h['jwt']
    jwt = JWT.decode(token, nil, nil).first
    assert_equal "db|#{people(:mach).id}", jwt['sub']
    assert_nil jwt['aud']
  end

  test "should be redirected with token for known requesting system added" do
    sign_in people(:mach)
    get :token, redirect_uri: URI::escape('https://knownsystem.svobodni.cz/callback.php'), format: :html
    uri = URI.parse(response.redirect_url)
    token = uri.query.split('&').collect{|kv| kv.split('=')}.to_h['jwt']
    jwt = JWT.decode(token, nil, nil).first
    assert_equal "db|#{people(:mach).id}", jwt['sub']
    assert_equal "knownsystem", jwt['aud']
  end

  test "should get profile using proper token" do
    request.headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJpc3MiOiJodHRwczovL3JlZ2lzdHIuc3ZvYm9kbmkuY3oiLCJzdWIiOiJkYnw3NDg5NzgzOTciLCJuYmYiOjE0MDM0MzAxMDgsImV4cCI6MTQwMzQzMzcwOCwiaWF0IjoxNDAzNDMwMTA4LCJqdGkiOiIwNzlhMTE4Mi0wNzQzLTRkYWYtOWZhYi0wODc0YzcyZjk3YzIiLCJ0eXAiOiJodHRwczovL3JlZ2lzdHIuc3ZvYm9kbmkuY3ovYXV0aCJ9.NYWFx9UwIkKSa-5D6c1l1q-s5A7R_ns5eJA4grrOYRWY_Ne9BvoNvTGVlUXa1_oU1qygSUCWQHWofp0exgF_9w"
    get :profile, format: :json
    assert_response :success
    person = JSON.parse(response.body)['person']
    assert_equal "mach@svobodni.cz", person['email']
    assert_equal "President", person['roles'].first['name']
  end

  test "should not get profile using a token with bad signature algorithm" do
    request.headers["Authorization"] = "Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJIUzI1NiJ9.eyJpc3MiOiJodHRwczovL3JlZ2lzdHIuc3ZvYm9kbmkuY3oiLCJzdWIiOiJkYnwxIiwibmJmIjoxNDAzNDMwMTA4LCJleHAiOjE0MDM0MzM3MDgsImlhdCI6MTQwMzQzMDEwOCwianRpIjoiMDc5YTExODItMDc0My00ZGFmLTlmYWItMDg3NGM3MmY5N2MyIiwidHlwIjoiSldUIn0.559Ctuj8IKkz5UnLrpgcL2D4Q7F0T6WhXgEaQwN0cvo"
    get :profile, format: :json
    assert_response :forbidden
    assert_equal "Access Denied", JSON.load(response.body)['error']
  end

  test "should not get profile using a token with bad signature" do
    request.headers["Authorization"] = "Bearer eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJodHRwczovL2p3dC1pZHAuZXhhbXBsZS5jb20iLCJzdWIiOiJkYnwxIiwibmJmIjoxNDA0Njg4MjcyLCJleHAiOjE0MDQ2OTE4NzIsImlhdCI6MTQwNDY4ODI3MiwianRpIjoiaWQxMjM0NTYiLCJ0eXAiOiJodHRwczovL2V4YW1wbGUuY29tL3JlZ2lzdGVyIn0.FVQXgSPvOzWW_tkNCLRviY7ZBDWdfUpLg59M8yqhbXKnD-UnbQgny7jKijL63N42_i2C_H7qoNDD13JSim8aXNFe8PXHJP-bkTBg4tcqff_s5W8CWZ-2gdlcNqadjmYRuS017mWwSeySK12jXTSShfNASPQhZdWk2rpJtbkKArZYyrAASd5-97FjkxPg_sRtlrwvyR8g0NaimYVXGw3x0dLRotYwXC20reqCbRoR8PlC5lAhB4LZ9LeSkNIpUw_1bKfAUJDbqCpx7i0QriALLbIrWj5ah4c1-F4ZEANKzP1aM8YdS39XECiov5Qc-7EGalx497LtQRQgWYMYgJkOGA"
    get :profile, format: :json
    assert_response :forbidden
    assert_equal "Access Denied", JSON.load(response.body)['error']
  end

end
