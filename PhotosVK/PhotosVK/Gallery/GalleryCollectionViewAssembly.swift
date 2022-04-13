//
//  GalleryCollectionViewAssembly.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import Foundation
import UIKit

protocol IGalleryCollectionViewAssembly {
    func createGalleryCollectionViewController() -> UIViewController
}

class GalleryCollectionViewAssembly: IGalleryCollectionViewAssembly {

    // MARK: - IGalleryCollectionViewAssembly protocol

    func createGalleryCollectionViewController() -> UIViewController {
        let presenter = GalleryCollectionViewPresenter()
        let view = GalleryViewController(presenter: presenter)
        presenter.view = view
        let navController = UINavigationController()
        navController.viewControllers = [view]
        return view
    }
}
