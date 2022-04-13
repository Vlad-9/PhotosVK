//
//  GalleryCollectionViewCell.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import UIKit

protocol IGalleryCollectionViewCell {

    func configure(with model: GalleryCellModel)
}

class GalleryCollectionViewCell: UICollectionViewCell {

    // MARK: - Properties

    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!

    // MARK: - Lifecycle

    override func awakeFromNib() {
        self.activityIndicator.hidesWhenStopped = true
        self.imageView.contentMode = .scaleAspectFill
        self.imageView.clipsToBounds = true
        super.awakeFromNib()
    }
}

// MARK: - IGalleryCollectionViewCell protocol

extension GalleryCollectionViewCell: IGalleryCollectionViewCell {

    func configure(with model: GalleryCellModel) {
        switch model.status {
        case .readyToLoad(_):
            activityIndicator.stopAnimating()
            imageView.image = nil
            backgroundColor = .clear

        case .loading:
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            imageView.image = nil
            backgroundColor = .clear

        case .image(let image):
            activityIndicator.stopAnimating()
            imageView.image = image
            backgroundColor = .clear

        case .failure:
            activityIndicator.stopAnimating()
            imageView.image = nil
            backgroundColor = .systemRed
        }
    }
}
