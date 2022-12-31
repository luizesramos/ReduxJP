//
//  AlbumsState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct Album: Codable {
    let userID: UserID
    let id: AlbumID
    let title: String
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
    }
}

extension Album: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.userID == rhs.userID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(userID)
        hasher.combine(id)        
        hasher.combine(title)
    }
}

struct Photo: Codable {
    let albumID: AlbumID
    let id: PhotoID
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

extension Photo: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id && lhs.albumID == rhs.albumID
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(albumID)
        hasher.combine(id)
        hasher.combine(title)
        hasher.combine(url)
    }
}

enum AlbumsViewState {
    case loading
    case failure
    case dataAvailable
}

enum SelectedAlbumState {
    case loading
    case failure
    case dataAvailable([Photo], User)
}

typealias AlbumID = UInt64
typealias PhotoID = UInt64

struct AlbumsState: ReduxState {
    var viewState: AlbumsViewState = .loading
    var albums: [Album] = .init()
    var cache: [AlbumID: SelectedAlbumState] = .init()
}
