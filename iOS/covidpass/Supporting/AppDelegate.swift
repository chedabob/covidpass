//
//  AppDelegate.swift
//  covidpass
//
//  Created by Matt Malone on 23/06/2021.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let photoLibrary = PhotoLibraryImpl()
    let network = NetworkImpl()
    let wallet = WalletImpl()

    private lazy var mainVc: UIViewController = { () -> UIViewController in
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let mainVc = storyboard.instantiateInitialViewController() as! MainViewController
        let mainVm = MainViewModelImpl(photoLibrary: photoLibrary, useCase: LoadPassUseCase(photoLibrary: photoLibrary, network: network, wallet: wallet))
        mainVm.view = mainVc
        mainVc.viewModel = mainVm
        return mainVc
    }()

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        let window = UIWindow(frame: UIScreen.main.bounds)
        window.makeKeyAndVisible()



        window.rootViewController = mainVc

        self.window = window

        return true
    }
}

