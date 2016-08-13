require 'hello_sign'
HelloSign.configure do |config|
  config.api_key = '8fcfb140f42716b88afadfb74930d72d2c4c7ef2520950272e5fd6f874afcb07'
  config.client_id = 'b0350215c8258b386d0efd63bc6d9e18'
  config.client_secret = 'ea2294cebb18f38f2b3109288bee4333'
   # You can use email_address and password instead of api_key. But api_key is recommended
  # If api_key, email_address and password are all present, api_key will be used
  # config.email_address = 'email_address'
  # config.password = 'pas
end

PDF_FILE = ['https://bitcoin.org/bitcoin.pdf']