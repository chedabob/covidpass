//
//  Network.swift
//  covidpass
//
//  Created by Matt Malone on 27/06/2021.
//

import Foundation

protocol Network {
    typealias PassCompletion = ((Data?, Error?)->())
    func getPass(from qrCode: String, with completion: @escaping PassCompletion)
}

class NetworkImpl: Network {
    let serverUrl = URL(string: "http://192.168.88.24:4567/pass")!

    func getPass(from qrCode: String, with completion: @escaping PassCompletion) {
        let json = [
            "qr_code": qrCode
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)
        var request = URLRequest(url: serverUrl)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "content-type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            completion(data, error)
        }
        task.resume()
    }
}
