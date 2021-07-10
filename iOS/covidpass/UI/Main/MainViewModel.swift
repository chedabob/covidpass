//
//  MainViewModel.swift
//  covidpass
//
//  Created by Matt Malone on 27/06/2021.
//

import Foundation
import UIKit

protocol MainView {
    var viewModel: MainViewModel! { get set }
    func present(pass: Pass)
    func hideContainers()
    func showAuthorization()
    func showSettings()
}

protocol MainViewModel {
    var view: MainView! { get set }
    func viewAppeared()
    func authorizedPressed()
    func settingsPressed()
}

class MainViewModelImpl: MainViewModel {
    var view: MainView!
    let photoLibrary: PhotoLibrary
    let useCase: LoadPassUseCase


    init(photoLibrary: PhotoLibrary, useCase: LoadPassUseCase) {
        self.photoLibrary = photoLibrary
        self.useCase = useCase
    }

    func viewAppeared() {
        refreshAuthorization()
        tryLoadQR()
    }

    func refreshAuthorization () {
        view.hideContainers()
        if photoLibrary.canRequestAuthorization {
            view.showAuthorization()
        } else if photoLibrary.isAuthorized == false {
            view.showSettings()
        }
    }

    func authorizedPressed() {
        photoLibrary.requestAuthorization {
            self.refreshAuthorization()
            self.tryLoadQR()
        }
    }

    private func tryLoadQR () {
        useCase.run { pass in
            DispatchQueue.main.async {
                self.view.present(pass: pass)
            }
        }
    }

    func settingsPressed() {
        UIApplication.shared.open(URL(string: UIApplication.openSettingsURLString)!)
    }
}
