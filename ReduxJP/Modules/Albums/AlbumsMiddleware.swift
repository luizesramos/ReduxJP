//
//  AlbumsMiddleware.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import Foundation

func albumsMiddleware(service: RESTServiceable) -> Middleware<AppState> {{ state, action, dispatch in
    switch action {
    case is FetchAlbums:
        Task {
            do {
                let albums = try await service.fetchAlbums().get()
                dispatch(UpdateAlbums(albums: albums))
            } catch {
                Log.albums.e(error.localizedDescription)
                dispatch(AlbumFetchFailed())
            }
        }
        
    case let action as LoadAlbum:
        Task {
            dispatch(UpdateSelectedAlbum(id: action.album.id, selectedAlbumState: .loading))
            do {
                let photos = try await service.fetchPhotos(albumID: action.album.id).get()
                let user = try await service.fetchUser(userID: action.album.userID).get()
                dispatch(UpdateSelectedAlbum(id: action.album.id, selectedAlbumState: .dataAvailable(photos, user)))
            } catch {
                Log.albums.e(error.localizedDescription)
                dispatch(UpdateSelectedAlbum(id: action.album.id, selectedAlbumState: .failure))
            }
        }
        
    default:
        break
    }
}}
