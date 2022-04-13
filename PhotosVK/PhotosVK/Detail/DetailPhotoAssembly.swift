//
//  DetailPhotoAssembly.swift
//  PhotosVK
//
//  Created by Влад on 10.04.2022.
//

import Foundation
import UIKit

protocol IDetailPhotoAssembly {
    func createDetailPhotoViewController(models: [GalleryCellModel],
                                         indPth: IndexPath) -> UIViewController
}

class DetailPhotoAssembly: IDetailPhotoAssembly {

    // MARK: - IDetailPhotoAssembly

    func createDetailPhotoViewController(models: [GalleryCellModel],
                                         indPth: IndexPath) -> UIViewController {
        let presenter = DetailPhotoPresenter(models: models,
                                             indPth: indPth)
        let view = DetailPhotoViewController(presenter: presenter)
        presenter.view = view
        return view
    }
}
