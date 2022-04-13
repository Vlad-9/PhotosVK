//
//  AuthViewController.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import Foundation
import UIKit

class AuthViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: IAuthPresenter

    // MARK: - Properties

    @IBAction func loginWithVKButton(_ sender: Any) {
        presenter.loginWithVK()
    }

    // MARK: - Initializers

    init(presenter: AuthPresenter) {
        self.presenter = presenter
        super.init(nibName: "AuthViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.viewDidLoad()
    }
}
