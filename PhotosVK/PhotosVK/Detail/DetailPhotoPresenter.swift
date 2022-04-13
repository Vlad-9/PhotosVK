//
//  DetailPhotoPresenter.swift
//  PhotosVK
//
//  Created by Влад on 10.04.2022.
//

import Foundation
import UIKit

protocol IDetailPhotoPresenter {
    func viewDidLoad()
    var models: [GalleryCellModel] { get }
    var indPth: IndexPath { get }
    func willDisplayCell(at indexPath: IndexPath, isPreview: Bool)
}

class DetailPhotoPresenter {
    
    // MARK: - Dependencies
    
    weak var view: DetailPhotoViewController?
    
    // MARK: - Properties
    
    var models: [GalleryCellModel]
    var indPth: IndexPath
    
    // MARK: - Initializers
    
    init(models: [GalleryCellModel], indPth: IndexPath) {
        self.indPth = indPth
        var newModels: [GalleryCellModel] = []
        for model in models {
            newModels.append(GalleryCellModel(
                status: .readyToLoad(URL(string: model.fullSizeLink)!) ,
                previewStatus: model.previewStatus,
                date: model.date,
                fullSizeLink: model.fullSizeLink
            ))
        }
        self.models = newModels
    }
}

// MARK: - IDetailPhotoPresenter protocol

extension DetailPhotoPresenter: IDetailPhotoPresenter {
    
    private func loadImage(at indexPath: IndexPath, with url: URL, isPreview: Bool) {
        
        if !isPreview {
            self.models[indexPath.row].status = .loading
        } else {
            self.models[indexPath.row].previewStatus = .loading
        }
        
        DispatchQueue.main.async {
            self.view?.updateCell(at: indexPath)
        }
        
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let data = data,
               let image = UIImage(data: data) {
                if !isPreview {
                    self.models[indexPath.row].status = .image(image)
                } else {
                    self.models[indexPath.row].previewStatus = .image(image)
                }
                
            } else {
                if !isPreview {
                    self.models[indexPath.row].status = .failure
                } else {
                    self.models[indexPath.row].previewStatus = .failure
                }
                self.models[indexPath.row].status = .failure
            }
            if let error = error {
                DispatchQueue.main.async {
                    self.view?.presentAlert(with: error.localizedDescription)
                }
            }
            
            DispatchQueue.main.async {
                self.view?.updateCell(at: indexPath)
            }
        }.resume()
    }
    
    func willDisplayCell(at indexPath: IndexPath, isPreview: Bool) {

        if !isPreview {
            switch models[indexPath.row].status {
            case .readyToLoad(let url):
                loadImage(at: indexPath, with: url, isPreview: isPreview)
                
            case .loading, .image(_), .failure:
                break
            }
        } else {
            do {
                switch models[indexPath.row].previewStatus {
                case .readyToLoad(let url):
                    
                    loadImage(at: indexPath, with: url, isPreview: isPreview)
                    
                case .loading, .image(_), .failure:
                    break
                }
            }
        }
    }
    
    func viewDidLoad() {
    }
}
