//
//  Network.swift
//  PhotosVK
//
//  Created by Влад on 07.04.2022.
//

import Foundation
import VK_ios_sdk

final class NetworkService {

    func request(token: String?, path: String, params: [String: String]) -> URL {
        var allParams = params
        allParams["access_token"] = token
        allParams["v"] = API.version
        var components = URLComponents()
        components.scheme = API.scheme
        components.host = API.host
        components.path = path
        components.queryItems = allParams.map { URLQueryItem(name: $0, value: $1) }
        print(components.url!)
        return components.url!
    }
}
