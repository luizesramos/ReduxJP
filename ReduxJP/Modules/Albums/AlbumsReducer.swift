//
//  AlbumsReducer.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import Foundation

func albumsReducer(state: AlbumsState, action: ReduxAction) -> AlbumsState {
    var state = state
    switch action {
    case is AlbumFetchFailed:
        state.viewState = .failure
        
    case let action as UpdateAlbums:
        state.viewState = .dataAvailable
        state.albums = action.albums
        
    case let action as UpdateSelectedAlbum:
        state.cache[action.id] = action.selectedAlbumState
        
    default:
        break
    }
    return state
}
