# Override your default settings for the Test environment here.
#
# Example:
#   configatron.file.storage = :local

configatron.auth.private_key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----\nMIIBOwIBAAJBALsl3zoyj4QoyIzxEOZ/o/xQ3nuJRBJdhMNC+5LXdlhKbfp42/px\n6xQk0G86+vQasoiJ51l/2IAzOA5FEFf1MVsCAwEAAQJBAIxYM1YWco/ecb9YTJ8+\nm0BteNrVronDPfuccMLG98XvCKoU7lVyYD1TgmNYJofzfP4m8VYGnQ5gNrjLT2Dn\n0ukCIQD1WLEGGrjCSbKrrOtJMaa/Mbl9E983a0b6uwi6vHE/vwIhAMNGPKhcs3e6\nO2O20AKZwYgZ1ZRsGbLKu0frgEHQC7VlAiEA62CNZMfaHTtLGHyqtevWh3MS+zZH\nXgmjbQRm2Y/ULk0CIFc+KhuOTyBOs/n40zZWO4DzCdkl8tVOfh3DuamtqY2BAiBr\nwj7J5ZE0hd9NDeB43tM26+3dgAfw2NfbcdysUjJhXw==\n-----END RSA PRIVATE KEY-----\n")
configatron.auth.systems = {
	'knownsystem' => 'https://knownsystem.svobodni.cz/callback.php'
}
configatron.migrated = true
configatron.finance.password = "testovaciheslo"

configatron.devise.secret_key = "pepazdepa"

configatron.twitter.consumer_key        = "conskey"
configatron.twitter.consumer_secret     = "seckey"
configatron.twitter.access_token        = "acctok"
configatron.twitter.access_token_secret = "acctoksec"

configatron.facebook.app_id = 'appid'
configatron.facebook.app_secret = 'appsec'
