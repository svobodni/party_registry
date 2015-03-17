# Override your default settings for the Development environment here.
#
# Example:
#   configatron.file.storage = :local

configatron.secret_key_base = '2bd450959dad5e41f09c976e3ec9c91e5d7bb6f12e8774953c778389f984fc2b0dc64357e7e04498c55b2a03cb04c255fb2b864152fa9089143484c0703cac08'

configatron.auth.private_key = OpenSSL::PKey::RSA.new("-----BEGIN RSA PRIVATE KEY-----\nMIIBOwIBAAJBALsl3zoyj4QoyIzxEOZ/o/xQ3nuJRBJdhMNC+5LXdlhKbfp42/px\n6xQk0G86+vQasoiJ51l/2IAzOA5FEFf1MVsCAwEAAQJBAIxYM1YWco/ecb9YTJ8+\nm0BteNrVronDPfuccMLG98XvCKoU7lVyYD1TgmNYJofzfP4m8VYGnQ5gNrjLT2Dn\n0ukCIQD1WLEGGrjCSbKrrOtJMaa/Mbl9E983a0b6uwi6vHE/vwIhAMNGPKhcs3e6\nO2O20AKZwYgZ1ZRsGbLKu0frgEHQC7VlAiEA62CNZMfaHTtLGHyqtevWh3MS+zZH\nXgmjbQRm2Y/ULk0CIFc+KhuOTyBOs/n40zZWO4DzCdkl8tVOfh3DuamtqY2BAiBr\nwj7J5ZE0hd9NDeB43tM26+3dgAfw2NfbcdysUjJhXw==\n-----END RSA PRIVATE KEY-----\n")
configatron.auth.systems = {
	'knownsystem' => 'https://knownsystem.svobodni.cz/callback.php'
}

configatron.old_web.sync_pass = "tajneheslo"

configatron.twitter.consumer_key        = "mG3Bni2iKZv70UkzeZwFZjVPu"
configatron.twitter.consumer_secret     = "YNl25W1vzlmNHUWLzfKfKWVTiZYRskby5D8dbGvyueukpEu3k9"
configatron.twitter.access_token        = "3072281596-MEipY28e9A4lUKuaH23PNQ00Vhcm9fBh0pUNCEB"
configatron.twitter.access_token_secret = "kGIHmBjIdTPcWwDR36hZQzS8LjBsyM77611EL29QX6tPL"
