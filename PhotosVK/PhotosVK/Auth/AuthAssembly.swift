//
//  AuthAssembly.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import Foundation
import UIKit

protocol IAuthAssembly {
    func createNoteViewController() -> UIViewController
}

class AuthAssembly: IAuthAssembly {

    // MARK: - IAuthAssembly protocol

    func createNoteViewController() -> UIViewController {
        let presenter = AuthPresenter()
        let view = AuthViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
