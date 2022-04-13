//
//  DetailPhotoViewController.swift
//  PhotosVK
//
//  Created by Влад on 10.04.2022.
//

import UIKit

protocol IDetailPhotoViewController {

    func presentAlert(with message: String)
    func updateCell(at indexPath: IndexPath)
}

class DetailPhotoViewController: UIViewController {

    // MARK: - Dependencies

    private let presenter: IDetailPhotoPresenter

    // MARK: - Properties

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var collectionView2: UICollectionView!

    // MARK: - Initializers

    init(presenter: DetailPhotoPresenter) {
        self.presenter = presenter
        super.init(nibName: "DetailPhotoViewController", bundle: nil)
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private

    private var initialScrollForMainImage = false
    private var initialScrollForPreviews = false
    private let dateFormatter = DateFormatter()

    private func snapToNearestCell(scrollView: UIScrollView) {
        let middlePoint = Int(scrollView.contentOffset.x + UIScreen.main.bounds.width / 2)
        guard let  indexPath = self.collectionView.indexPathForItem(at: CGPoint(x: middlePoint, y: 0))
        else {
            return
        }
        self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.setNavigationBarUI(date: dateFormatter.string(from: presenter.models[indexPath.row].date))
    }

    @objc private func shareImage() {

        var imageToShare: [UIImage] = []
        switch presenter.models[self.collectionView.indexPathsForVisibleItems.first!.row].status {

        case .image(let image):
            imageToShare.append(image)
        case .loading:  self.presentAlert(with: NSLocalizedString("shareErrorLoadingDescription", comment: ""))
            return
        case  .readyToLoad(_), .failure:
            self.presentAlert(with: NSLocalizedString("shareErrorDescription", comment: ""))
            return
        }

        let activityViewController =
        UIActivityViewController(activityItems: imageToShare as [Any],
                                 applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        activityViewController.completionWithItemsHandler = {_, completed, _, error in
            if !completed {
                self.presentAlert(with: NSLocalizedString("imageNotSaved", comment: ""))
                return
            }
            if let error = error {
                self.presentAlert(with: error.localizedDescription)
            }
            self.presentAlert(with: NSLocalizedString("imageSaved", comment: ""))
        }

        self.present(activityViewController, animated: true, completion: nil)
    }

    private func setNavigationBarUI(date: String) {
        let shareButton = UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"),
                                          style: .plain,
                                          target: self,
                                          action: #selector(shareImage))
        self.navigationItem.rightBarButtonItem = shareButton
        self.navigationItem.title = date
        let backButton = UIBarButtonItem()
        self.navigationController?.navigationBar.topItem?.backBarButtonItem = backButton
        self.navigationController?.navigationBar.tintColor = .black
    }

    private func makeLayoutForCollectionView() -> UICollectionViewFlowLayout {
        let flowlayout = UICollectionViewFlowLayout()
        flowlayout.itemSize = CGSize(width: UIScreen.main.bounds.width, height: collectionView.frame.size.height)
        flowlayout.minimumInteritemSpacing = 0
        flowlayout.minimumLineSpacing = 0
        flowlayout.scrollDirection = .horizontal
        return flowlayout
    }

    private func setupUI() {
        self.setNavigationBarUI(date: dateFormatter.string(from: presenter.models[presenter.indPth.row].date))
        collectionView.collectionViewLayout = makeLayoutForCollectionView()
        collectionView.decelerationRate = .fast
        collectionView.register(UINib(nibName: "DetailCollectionViewCell",
                                      bundle: nil),
                                forCellWithReuseIdentifier: "collectionViewCell")
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView2.register(UINib(nibName: "DetailCollectionViewCell",
                                       bundle: nil),
                                 forCellWithReuseIdentifier: "collectionViewCell")
        collectionView2.delegate = self
        collectionView2.dataSource = self

    }

    // MARK: - LifeCycle

    override func viewDidLoad() {
        dateFormatter.dateFormat = "d MMMM yyyy"
        setupUI()
        super.viewDidLoad()
    }

    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        self.snapToNearestCell(scrollView: scrollView)
    }

    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView == self.collectionView {
            self.snapToNearestCell(scrollView: scrollView)
        }
    }
    func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if scrollView == self.collectionView {
            if !decelerate {
                self.snapToNearestCell(scrollView: scrollView)
            }
        }
    }
}

// MARK: - IDetailPhotoViewController protocol

extension DetailPhotoViewController: IDetailPhotoViewController {

    func presentAlert(with message: String) {
        let alert = UIAlertController(title: message, message: nil, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "ОК", style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)

    }

    func updateCell(at indexPath: IndexPath) {
        collectionView.reloadItems(at: [indexPath])
        collectionView2.reloadItems(at: [indexPath])

    }
}

// MARK: - UICollectionViewDelegate protocol

extension DetailPhotoViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView,
                        didSelectItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView2 {
            self.collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
            self.collectionView2.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        }
    }

    func collectionView(_ collectionView: UICollectionView,
                        willDisplay cell: UICollectionViewCell,
                        forItemAt indexPath: IndexPath) {
        if collectionView == self.collectionView {
            if !initialScrollForMainImage {
                collectionView.scrollToItem(at: presenter.indPth, at: .centeredHorizontally, animated: false)
                initialScrollForMainImage = true

            }
            presenter.willDisplayCell(at: indexPath, isPreview: false)

        } else if collectionView == self.collectionView2 {
            if !initialScrollForPreviews {
                collectionView.scrollToItem(at: presenter.indPth, at: .centeredHorizontally, animated: false)
                initialScrollForPreviews = true
            }
        }
    }
}

// MARK: - UICollectionViewDataSource protocol

extension DetailPhotoViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "collectionViewCell",
            for: indexPath as IndexPath
        ) as? DetailCollectionViewCell   else { return UICollectionViewCell() }
        cell.imageView.image = nil
        if collectionView == self.collectionView {
            cell.configure(with: presenter.models[indexPath.row], isPreview: false)

        } else {
            presenter.willDisplayCell(at: indexPath, isPreview: true)
            cell.configure(with: presenter.models[indexPath.row], isPreview: true)
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView,
                        numberOfItemsInSection section: Int) -> Int {
        return presenter.models.count
    }
}

extension Date {
  var localizedStringTime: String {
    return DateFormatter.localizedString(from: self, dateStyle: .none, timeStyle: .short)
  }
}
