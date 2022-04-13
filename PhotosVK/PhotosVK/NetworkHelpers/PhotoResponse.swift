//
//  PhotosResponse.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

struct PhotoResponseWrapped: Decodable {
    let response: PhotoResponse
}

struct PhotoResponse: Decodable {
    var items: [PhotoItem]
    var count: Int
}

struct PhotoItem: Codable {
    let sizes: [PhotoSize]
    let date: Double
}

struct PhotoSize: Codable {
    let type: String
    let url: String
    let width: Int
    let height: Int
}
