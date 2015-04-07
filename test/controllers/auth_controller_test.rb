# encoding: utf-8
require 'test_helper'

class AuthControllerTest < ActionController::TestCase

  setup do
    @public_key = "-----BEGIN PUBLIC KEY-----\nMFwwDQYJKoZIhvcNAQEBBQADSwAwSAJBALsl3zoyj4QoyIzxEOZ/o/xQ3nuJRBJd\nhMNC+5LXdlhKbfp42/px6xQk0G86+vQasoiJ51l/2IAzOA5FEFf1MVsCAwEAAQ==\n-----END PUBLIC KEY-----\n"
    @person = FactoryGirl.create(:person, member_status: "regular")
    now = Time.now
    @token = JWT.encode({iss: "https://registr.svobodni.cz",
      sub: "db|#{@person.id}",
      nbf: now.to_i,
      exp: (now+1.hour).to_i,
      iat: now.to_i,
      jti: SecureRandom.uuid,
      typ: "https://registr.svobodni.cz/auth"}, configatron.auth.private_key, "RS256")
  end

  test "should get public_key" do
    get :public_key, format: :json
    assert_response :success
    assert_equal @public_key, response.body
  end

  test "should get token with valid signature" do
    sign_in @person
    get :token, format: :json
    assert_response :success
    public_key = OpenSSL::PKey::RSA.new(@public_key)
    JWT.decode(response.body, public_key)
  end

  test "should not get token unless regular person" do
    sign_in FactoryGirl.create(:person, member_status: "awating_first_payment")
    get :token, format: :json
    assert_response 403
    assert_equal '{"error":"Access Denied"}', response.body
  end

  test "should not get token unless regular supporter" do
    sign_in FactoryGirl.create(:person, supporter_status: "registered")
    get :token, format: :json
    assert_response 403
    assert_equal '{"error":"Access Denied"}', response.body
  end

  test "should get token with proper content" do
    sign_in @person
    get :token, format: :json
    assert_response :success
    jwt = JWT.decode(response.body, nil, nil).first
    assert_equal "db|#{@person.id}", jwt['sub']
  end

  test "should be redirected with token added" do
    sign_in @person
    get :token, redirect_uri: 'https://somesystem.cz/callback.php', format: :html
    assert_response :redirect
    uri = URI.parse(response.redirect_url)
    assert_equal 'somesystem.cz', uri.host
    assert_equal '/callback.php', uri.path
    token = uri.query.split('&').collect{|kv| kv.split('=')}.to_h['jwt']
    jwt = JWT.decode(token, nil, nil).first
    assert_equal "db|#{@person.id}", jwt['sub']
    assert_equal "https://somesystem.cz/callback.php", jwt['aud']
  end

  test "should be redirected with token for known requesting system added" do
    sign_in @person
    get :token, redirect_uri: URI::escape('https://knownsystem.svobodni.cz/callback.php'), format: :html
    uri = URI.parse(response.redirect_url)
    token = uri.query.split('&').collect{|kv| kv.split('=')}.to_h['jwt']
    jwt = JWT.decode(token, nil, nil).first
    assert_equal "db|#{@person.id}", jwt['sub']
    assert_equal "knownsystem", jwt['aud']
  end

  test "should get profile using proper token" do
    request.headers["Authorization"] = "Bearer #{@token}"
    get :profile, format: :json
    assert_response :success
    person = JSON.parse(response.body)['person']
    assert_equal @person.email, person['email']
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
