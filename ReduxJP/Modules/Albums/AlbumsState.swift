//
//  AlbumsState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct Album: Codable {
    let userID: String
    let id: String
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
    }
}

struct AlbumsState: ReduxState {
    var selectedAlbumID: String? = nil
    var albums: [Album] = .init()
}
