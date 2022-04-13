//
//  AuthPresenter.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import Foundation

protocol IAuthPresenter {
    func loginWithVK()
    func viewDidLoad()
}

class AuthPresenter: IAuthPresenter {

    // MARK: - Dependencies

    private var authService: AuthService!
    weak var view: AuthViewController?

    // MARK: - IAuthPresenter protocol

    func loginWithVK() {
        authService.wakeUpSession()
    }

    func viewDidLoad() {
        authService = SceneDelegate.shared().authService
    }
}
