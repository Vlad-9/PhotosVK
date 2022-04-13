//
//  GalleryViewController.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import UIKit

protocol IGalleryViewController {
    func updateCell(at indexPath: IndexPath)
}

final class GalleryViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: IGalleryCollectionViewPresenter

    // MARK: - Properties

    let reuseIdentifier = "Cell"
    @IBOutlet weak var collectionView: UICollectionView!

    func presentAlert(with message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }
    // MARK: - Initializers

    init(presenter: IGalleryCollectionViewPresenter) {
        self.presenter = presenter
        super.init(nibName: "GalleryViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    @objc private func userLogOut() {
        presenter.logOut()
        navigationController?.popViewController(animated: true)
    }

    private func setNavigationBarUI() {
        let exitButton = UIBarButtonItem(title: NSLocalizedString("exit", comment: ""),
                                         style: .plain,
                                         target: self,
                                         action: #selector(userLogOut))
        exitButton.tintColor = .black
        self.navigationItem.rightBarButtonItem = exitButton
        self.navigationItem.hidesBackButton = true
        self.navigationItem.title = "Mobile Up Gallery"
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        collectionView.register(UINib(nibName: "GalleryCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: reuseIdentifier)
        collectionView.dataSource = self
        collectionView.delegate = self
        super.viewDidLoad()
        presenter.viewDidLoad()
        setNavigationBarUI()
    }
}

// MARK: - IGalleryViewController protocol

extension GalleryViewController: IGalleryViewController {

    func updateCell(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
    }
}

// MARK: - UICollectionViewDataSource protocol

extension GalleryViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: reuseIdentifier,
            for: indexPath as IndexPath
        ) as? GalleryCollectionViewCell
        else { return UICollectionViewCell() }
        cell.imageView.image = nil
        cell.configure(with: presenter.models[indexPath.row])
        return cell
    }

    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        presenter.models.count
    }
}

// MARK: - UICollectionViewDelegate protocol

extension GalleryViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        self.navigationController?
            .pushViewController(DetailPhotoAssembly()
                                    .createDetailPhotoViewController(
                                        models: presenter.models,
                                        indPth: indexPath),
                                animated: true
            )
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        presenter.willDisplayCell(at: indexPath)
    }
}

// MARK: - UICollectionViewDelegateFlowLayout protocol

extension GalleryViewController: UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView,
                        layout collectionViewLayout: UICollectionViewLayout,
                        sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) +
        (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        let size: CGFloat = (collectionView.frame.size.width - space) / 2.0
        return CGSize(width: size, height: size)
    }
}
