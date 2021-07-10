require 'cbor'
require 'date'

class QRParser
  def self.parse(qrcode)
    container = CBOR.decode(qrcode)
    pass = CBOR.decode(container[1][2])
    expiry = Time.at(pass[4]).to_datetime
    doses = pass[-260][1]['v']
    tidy_doses = doses.map { |dose| QRParser.make_dose dose }
    vax_name = QRParser.friendly_vaccine doses[0]['mp']
    dob = pass[-260][1]['dob']
    firstname = pass[-260][1]['nam']['gn']
    surname = pass[-260][1]['nam']['fn']

    {
      'name' => "#{firstname} #{surname}",
      'vax_name' => vax_name,
      'dob' => dob,
      'expiry' => expiry,
      'doses' => tidy_doses
    }

  end

  private

  def self.make_dose(dose)
    {
      'manufacturer' => QRParser.friendly_vaccine(dose['mp']),
      'date' => Date.parse(dose['dt']),
      'num' => dose['dn']
    }
  end

  def self.friendly_vaccine(license_no)
    if license_no == 'EU/1/20/1528'
      'Pfizer'
    elsif license_no == 'EU/1/21/1529'
      'AstraZeneca'
    elsif license_no == 'EU/1/20/1507'
      'Moderna'
    end
  end
end