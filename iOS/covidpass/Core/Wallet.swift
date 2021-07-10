//
//  Wallet.swift
//  covidpass
//
//  Created by Matt Malone on 27/06/2021.
//

import Foundation
import PassKit

protocol Wallet {
    func loadPass(with data: Data) -> Pass?
}

class WalletImpl: Wallet {
    func loadPass(with data: Data) -> Pass? {
        do {
            let passPkg = try PKPass(data: data)
            return passPkg
        } catch {
            // TODO Implement error handling
            return nil
        }
    }
}
