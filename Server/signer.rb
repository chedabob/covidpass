require 'passbook'

class Signer
  def self.sign(raw_pass)
    Passbook.configure do |passbook|
      passbook.p12_password = ''
      passbook.p12_key = 'covidpass.pem'
      passbook.p12_certificate = 'covidcert.pem'
      passbook.wwdc_cert = 'wwdr.pem'
    end

    pass = Passbook::PKPass.new raw_pass

    # Add multiple files
    pass.addFiles %w[icon.png icon@2x.png icon@3x.png logo.png logo@2x.png logo@3x.png]

    pass.stream.string
  rescue => error
    puts error
  end
end
