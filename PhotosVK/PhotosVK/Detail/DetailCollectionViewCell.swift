//
//  DetailCollectionViewCell.swift
//  PhotosVK
//
//  Created by Влад on 12.04.2022.
//

import UIKit

class DetailCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var imageView: UIImageView!

    func configure(with model: GalleryCellModel, isPreview: Bool) {
        if !isPreview {
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
        } else {
            switch model.previewStatus {
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

    @objc func pinch(sender: UIPinchGestureRecognizer) {
        if sender.state == .began || sender.state == .changed {
            let currentScale = self.imageView.frame.size.width / self.imageView.bounds.size.width
            let newScale = currentScale*sender.scale
            let transform = CGAffineTransform(scaleX: newScale, y: newScale)
            self.imageView.transform = transform
            sender.scale = 1
        }
    }

    override func awakeFromNib() {
        self.activityIndicator.hidesWhenStopped = true
        super.awakeFromNib()
        let pinch = UIPinchGestureRecognizer(target: self, action: #selector(pinch))
        imageView.addGestureRecognizer(pinch)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        imageView?.image = nil
        imageView.transform = .identity
    }
}
