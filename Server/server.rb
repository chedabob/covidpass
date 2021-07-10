require 'sinatra'
require 'base64'
require 'cgi'
require 'zlib'

require_relative 'signer'
require_relative 'pass_generator'
require_relative 'qr_parser'
require_relative 'base45'

set :bind, '0.0.0.0'

post "/pass" do
  request.body.rewind
  request_payload = JSON.parse request.body.read

  qr_code = request_payload['qr_code']
  stripped = qr_code[4..-1]
  unencoded = Base45.decode stripped
  decompressed = Zlib::Inflate.inflate unencoded

  payload = QRParser.parse decompressed

  raw_pass = PassGenerator.gen(payload, qr_code)
  signed_pass = Signer.sign(raw_pass)
  response['Content-Type'] = 'application/vnd.apple.pkpass'
  signed_pass
end
