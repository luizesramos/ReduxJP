//
//  PhotosState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct Photo: Codable {
    let albumID: String
    let id: String
    let title: String
    let url: URL
    let thumbnailURL: URL
    
    enum CodingKeys: String, CodingKey {
        case albumID = "albumId"
        case id
        case title
        case url
        case thumbnailURL = "thumbnailUrl"
    }
}

struct PhotosState: ReduxState {
    var photos: [Photo]
}
