# Server for CovidPass

## Prerequisites

1. Ruby 2.7 installed (RVM recommended)
1. Private key for Wallet certificate in PEM format (no password)
1. Wallet certificate in PEM format (no password)

## Usage
1. Install dependencies with `bundle install`
1. In the same folder as `wwdr.pem` add your Wallet signing key as `covidpass.pem` and the certificate as `covidcert.pem`
1. Run the server with `ruby server.rb`