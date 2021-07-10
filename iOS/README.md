# iOS app for CovidPass

## Prerequisites
* App ID created in the Apple Developer portal
* Provisioning profile for App ID installed on developer machine
* Developer certificate and key that can use the provisioning profile installed on developer machine
* CovidPass server running

## Setup

1. Change the bundle ID to match yours
1. Change the Team to yours
1. In `Network.swift` change `serverUrl` to where your server is running

## Usage

1. Open the NHS app, find your Covid pass, and take a screenshot of it
1. Launch CovidPass, follow the instructions