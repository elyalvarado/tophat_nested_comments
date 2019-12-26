require 'devise/jwt/test_helpers'

module JWTAuthenticationHelpers
  def jwt_auth_headers_for user, headers = {}
    Devise::JWT::TestHelpers.auth_headers(headers, user)
  end
end