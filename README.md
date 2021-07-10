# Apple Wallet pass generator for Covid pass


iOS app and Ruby server for turning an NHS Covid pass into an Apple Wallet pass

This is merely a proof-of-concept to demonstrate parsing the QR code and then generating a PassKit payload that can be installed on device. I am not responsible for anything that might happen if you use this in the real world.

Note: The QR code shown in Wallet does not exactly match the NHS code as Apple use a different amount of error correction. The code should still scan the same, although this has not been tested.

## Requirements

* Apple Developer program membership (to generate the pass signing certificate)

## Setup

Follow the instructions in the `Server` README, then follow the instructions in the `iOS` README