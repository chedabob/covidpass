require 'date'
require 'json'

class PassGenerator
  def self.gen(payload, qr_code)
    date = payload['expiry']

    barcode = {
      'message' => qr_code,
      'format' => 'PKBarcodeFormatQR',
      'messageEncoding' => 'iso-8859-1'
    }

    pass = {
      'formatVersion' => 1,
      'passTypeIdentifier' => 'pass.com.mattm.covidtest',
      'serialNumber' => date.strftime('%s'),
      'teamIdentifier' => '6GVCVGN5W5',
      'expirationDate' => date.iso8601(),
      'barcode' => barcode,
      'organizationName' => 'mattm',
      'description' => 'NHS COVID Pass',
      'foregroundColor' => 'rgb(35, 31, 32)',
      'labelColor' => 'rgb(35, 31, 32)',
      'backgroundColor' => 'rgb(0, 94, 184)',
      'logoText' => 'COVID Pass',
      'storeCard' => {
        'primaryFields' => [
          make_field('dosecount', make_dose_text(payload['doses'])),
        ],
        'secondaryFields' => [
          make_field_label('second', payload['dob'], payload['name'])
        ],
        'backFields' => payload['doses'].map { |dose| make_dose_field(dose)}
      }
    }

    JSON.generate(pass)
  end

  private

  def self.make_field(key, value)
    {
      'key' => key,
      'value' => value
    }
  end

  def self.make_field_label(key, value, label)
    {
      'key' => key,
      'value' => value,
      'label' => label
    }
  end

  def self.make_dose_text(doses)
    if doses.empty?
      "No doses"
    elsif doses.length == 1
      "1 dose"
    else
      "#{doses.length} doses"
    end
  end

  def self.make_dose_field(dose)
    date = dose['date'].strftime('%d/%m/%Y')
    manu = dose['manufacturer']
    text = "#{dose['num']}. #{date} - #{manu}"
    make_field("dose#{dose['num']}", text )
  end
end