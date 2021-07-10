//
//  ViewController.swift
//  covidpass
//
//  Created by Matt Malone on 23/06/2021.
//

import MobileCoreServices
import PassKit
import UIKit
import ZIPFoundation

class MainViewController: UIViewController, MainView {

    var viewModel: MainViewModel!
    @IBOutlet weak var authorizeContainer: UIView!
    @IBOutlet weak var settingsContainer: UIView!

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        viewModel!.viewAppeared()
    }

    @IBAction func authorizePressed(_ sender: Any) {
        viewModel.authorizedPressed()
    }

    @IBAction func openSettingsPressed(_ sender: Any) {
        viewModel.settingsPressed()
    }

    func present(pass: Pass) {
        let passvc = PKAddPassesViewController(pass: pass as! PKPass)
        self.present(passvc!, animated: true)
    }

    func hideContainers () {
        authorizeContainer.isHidden = true
        settingsContainer.isHidden = true
    }

    func showAuthorization() {
        authorizeContainer.isHidden = false
    }

    func showSettings() {
        settingsContainer.isHidden = false
    }


}



extension MainViewController {
    

    func getPass(from qrCode: String) {
        let json = [
            "qr_code": qrCode
        ]

        let jsonData = try? JSONSerialization.data(withJSONObject: json)

        // create post request
        let url = URL(string: "http://192.168.88.24:4567/pass")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        // insert json data to the request
        request.httpBody = jsonData
        request.setValue("application/json", forHTTPHeaderField: "content-type")

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                print(error?.localizedDescription ?? "No data")
                return
            }
            do {
                let passPkg = try PKPass(data: data)
                let passvc = PKAddPassesViewController(pass: passPkg)!
                DispatchQueue.main.async {
                    self.dismiss(animated: true) {
                        self.present(passvc, animated: true)
                    }
                }
            }
            catch {

            }
        }

        task.resume()
    }
}
