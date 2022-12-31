//
//  AlbumPhotosView.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import SwiftUI

struct AlbumPhotosView: View {
    @EnvironmentObject var store: Store<AppState>
    public let item: Album
    
    public init(item: Album) {
        self.item = item
    }
    
    struct Props {
        var state: SelectedAlbumState
        var loadAlbum: () -> Void
    }
    
    private func map(state: AlbumsState) -> Props {
        Props(state: state.cache[item.id] ?? .loading,
              loadAlbum: { store.dispatch(action: LoadAlbum(album: item))})
    }
    
    private var props: Props {
        map(state: store.state.albumsState)
    }
    
    var body: some View {
        Group {
            switch props.state {
            case .loading:
                loadingView
            case .failure:
                failureView
            case let .dataAvailable(photos, user):
                VStack {
                    NavigationLink("Photos by \(user.username)", value: user)
                    photosView(photos)
                }
            }
        }
        .navigationTitle(item.title)
        .navigationBarTitleDisplayMode(.inline)
        .navigationDestination(for: User.self) { user in
            Text(user.name)
        }
        .navigationDestination(for: Photo.self) { item in
            Text(item.title)
        }
        .onAppear {
            props.loadAlbum()
        }
    }
    
    @ViewBuilder
    private var loadingView: some View {
        ProgressView()
    }
    
    @ViewBuilder
    private var failureView: some View {
        VStack {
            Text("Failed to load photos. Please try again.")
                .padding()
            Button("Retry") {
                store.dispatch(action: LoadAlbum(album: item))
            }
        }
    }
    
    @ViewBuilder
    private func photosView(_ photos: [Photo]) -> some View {
        ScrollableLazyVGrid(config: .init(), items: photos) { item, imageSize in
            VStack {
                NavigationLink(value: item) {
                    ThumbnailAsyncImage(url: item.thumbnailURL, imageSize: imageSize)
                }
                
                Text(item.title)
                    .lineLimit(1)
                    .truncationMode(.tail)
                Spacer()
            }
        }
    }
}

struct AlbumPhotosView_Previews: PreviewProvider {
    private static let item = Album(userID: 5, id: 1, title: "Test")
    private static let albumStateLoading = AlbumsState(viewState: .loading)
    private static let albumStateFailure = AlbumsState(viewState: .failure)
    private static let albumStateDataAvailable = AlbumsState(
        viewState: .dataAvailable,
        cache: [
            1: .dataAvailable(Preview.photoList(itemCount: 15), Preview.user(5, "Larry"))
        ]
    )
    
    static var previews: some View {
        Group {
            AlbumPhotosView(item: item)
                .environmentObject(Store<AppState>(state: .init(albumsState: albumStateLoading),
                                                   reducer: appReducer,
                                                   midlewares: []))
            
            AlbumPhotosView(item: item)
                .environmentObject(Store<AppState>(state: .init(albumsState: albumStateFailure),
                                                   reducer: appReducer,
                                                   midlewares: []))
            
            AlbumPhotosView(item: item)
                .environmentObject(Store<AppState>(state: .init(albumsState: albumStateDataAvailable),
                                                   reducer: appReducer,
                                                   midlewares: []))
        }
    }
}
