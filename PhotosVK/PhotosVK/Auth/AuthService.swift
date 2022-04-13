//
//  AuthService.swift
//  PhotosVK
//
//  Created by Влад on 11.04.2022.
//

import Foundation
import VK_ios_sdk

protocol AuthServiceDelegate: AnyObject {
    func authServiceShould(viewController: UIViewController)
    func authServiceSignIn()
    func authServiceSignInDidFail()
    func authServiceLogout()
    func failedAuth()
}

protocol IAuthService {
    func logOut()
    func isAlreadyAuthorized()
    func wakeUpSession()
    var token: String? { get }
}

class AuthService: NSObject {

    // MARK: - Dependencies

    private let vkSdk: VKSdk
    weak var delegate: AuthServiceDelegate?

    // MARK: - Properties

    private let appId =  "8128788"

    // MARK: - Initializers

    override init() {
        vkSdk = VKSdk.initialize(withAppId: appId)
        super.init()
        print("VKSdk.initialize")
        vkSdk.register(self)
        vkSdk.uiDelegate = self

    }
}

// MARK: - VKSdkDelegate protocol

extension AuthService: VKSdkDelegate {

    func vkSdkUserAuthorizationFailed() {
        print(#function)
        delegate?.authServiceSignInDidFail()
    }
    func vkSdkAccessAuthorizationFinished(with result: VKAuthorizationResult!) {
        print(#function)
        if result.token != nil {
            delegate?.authServiceSignIn()
        } else {
            delegate?.failedAuth()
        }
    }
}

// MARK: - VKSdkUIDelegate protocol

extension AuthService: VKSdkUIDelegate {

    func vkSdkNeedCaptchaEnter(_ captchaError: VKError!) {
        print(#function)
    }
    func vkSdkShouldPresent(_ controller: UIViewController!) {
        print(#function)

        delegate?.authServiceShould(viewController: controller)
    }
}

// MARK: - IAuthService protocol

extension AuthService: IAuthService {
    var token: String? {
        return VKSdk.accessToken()?.accessToken
    }

    func logOut() {
        VKSdk.forceLogout()
        delegate?.authServiceLogout()
    }

    func isAlreadyAuthorized() {

        VKSdk.wakeUpSession(nil) { (state: VKAuthorizationState, error: Error?)   in
            if state == .authorized {
                self.delegate?.authServiceSignIn()
            } else if (error) != nil {
                print("wakeUpSession error: \(error!.localizedDescription)")
            }
            print("state \(state)")

        }
    }

    func wakeUpSession() {
        let scope = [""]
        VKSdk.wakeUpSession(scope) {[delegate] state, _ in
            switch state {
            case .initialized:
                print("initialized")
                VKSdk.authorize(scope)
            case .authorized:
                print("authorized")
                delegate?.authServiceSignIn()
            default:
                delegate?.authServiceSignInDidFail()
            }
        }
    }
}
