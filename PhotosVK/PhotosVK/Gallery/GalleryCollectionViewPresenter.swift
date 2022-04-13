//
//  GalleryCollectionViewPresenter.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import Foundation
import UIKit
import Alamofire

enum GalleryCellStatus {
    case readyToLoad(URL)
    case loading
    case image(UIImage)
    case failure
}

struct GalleryCellModel {
    var status: GalleryCellStatus
    var previewStatus: GalleryCellStatus
    let date: Date
    var fullSizeLink: String
}

protocol IGalleryCollectionViewPresenter {

    func willDisplayCell(at indexPath: IndexPath)
    func loadLinks()
    func viewDidLoad()
    func logOut()
    var models: [GalleryCellModel] { get }
}

final class GalleryCollectionViewPresenter {

    // MARK: - Dependencies

    private let authService: IAuthService
    private let networkService =  NetworkService()
    weak var view: GalleryViewController?

    // MARK: - Initializers

    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }

    // MARK: - Properties

    private(set) var models: [GalleryCellModel] = Array(
        repeating: GalleryCellModel(status: .loading, previewStatus: .loading, date: .now, fullSizeLink: "" ),
        count: 1
    )

    // MARK: - Private

    private func loadImage(at indexPath: IndexPath, with url: URL) {
        self.models[indexPath.row].status = .loading
        DispatchQueue.main.async {
            self.view?.updateCell(at: indexPath)
        }

        URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let data = data,
               let image = UIImage(data: data) {
                self.models[indexPath.row].status = .image(image)
            } else {
                self.models[indexPath.row].status = .failure
            }

            DispatchQueue.main.async {
                self.view?.updateCell(at: indexPath)
            }
        }.resume()
    }
}

// MARK: - IGalleryCollectionViewPresenter protocol

extension GalleryCollectionViewPresenter: IGalleryCollectionViewPresenter {

    func logOut() {
        authService.logOut()
    }

    func loadLinks() {
        let params = ["album_id": "266276915", "owner_id": "-128666765"]
        let url = self.networkService.request(token: authService.token, path: API.photos, params: params)

        AF.request(url).responseDecodable(of: PhotoResponseWrapped.self) { response in
            switch response.result {
            case .success(let photoResponseWrapped):
                self.models = []

                for item in photoResponseWrapped.response.items {

                    if let url = URL(string: item.sizes.filter { $0.type == "x" }.first!.url) {

                        self.models.append(GalleryCellModel(
                            status: .readyToLoad(url) ,
                            previewStatus: .readyToLoad(URL(string: item.sizes.filter { $0.type == "q" }.first!.url)!),
                            date: Date(timeIntervalSince1970: item.date),
                            fullSizeLink: item.sizes.filter { $0.type == "w" }.first!.url
                        ))
                    }
                }
                self.view?.collectionView.reloadData()

            case .failure(let error):
                print("Failed with error: \(error)")
            }
        }
    }

    func viewDidLoad() {
        view?.collectionView.reloadData()
        self.loadLinks()
    }

    func willDisplayCell(at indexPath: IndexPath) {

        switch models[indexPath.row].status {
        case .readyToLoad(let url):
            loadImage(at: indexPath, with: url)

        case .loading, .image(_), .failure: //
            break
        }
    }
}
