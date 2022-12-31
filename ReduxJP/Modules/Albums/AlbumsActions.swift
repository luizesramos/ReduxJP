//
//  AlbumsActions.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import Foundation

struct FetchAlbums: ReduxAction {}

struct AlbumFetchFailed: ReduxAction {}

struct UpdateAlbums: ReduxAction {
    let albums: [Album]
}

struct LoadAlbum: ReduxAction {
    let album: Album
}

struct UpdateSelectedAlbum: ReduxAction {
    let id: AlbumID
    let selectedAlbumState: SelectedAlbumState
}
