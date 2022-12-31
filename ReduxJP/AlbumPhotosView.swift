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
    private func photosView(_ photos: [Photo], gridConfig: GridConfigurations = .init()) -> some View {
        GeometryReader { g in
            let imageSize = gridConfig.imageSize(for: g.size)
            
            ScrollView {
                LazyVGrid(columns: gridConfig.gridItemLayout, spacing: 20) {
                    ForEach(photos, id: \.self) { item in
                        VStack {
                            NavigationLink(value: item) {
                                AsyncImage(url: item.thumbnailURL, content: { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: imageSize, height: imageSize)
                                        .clipped()
                                }, placeholder: {
                                    ZStack {
                                        Color.gray.opacity(0.5)
                                        ProgressView()
                                    }
                                })
                            }
                            
                            Text(item.title)
                                .lineLimit(1)
                                .truncationMode(.tail)
                            Spacer()
                        }
                    }
                }
            }
        }
    }
}

struct GridConfigurations {
    let gridSpacing: CGFloat = 2
    let gridItemsPerRow: Int = 4
    
    var gridItemLayout: [GridItem] {
        let item = GridItem(.flexible(), spacing: gridSpacing)
        return (0 ..< gridItemsPerRow).reduce(into: []) { partialResult, _ in
            partialResult.append(item)
        }
    }
    
    func imageSize(for size: CGSize) -> CGFloat {
        let itemsPerRow = CGFloat(gridItemsPerRow)
        return (min(size.width, size.height) - (itemsPerRow * gridSpacing)) / itemsPerRow
    }
}

struct AlbumPhotosView_Previews: PreviewProvider {
    private static let item = Album(userID: 5, id: 1, title: "Test")
    private static let url = URL(string: "https://images.unsplash.com/photo-1580275595586-1c706a501b57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJlZSUyMGJpcmR8ZW58MHx8MHx8&w=1000&q=80")!
    private static let albumStateLoading = AlbumsState(viewState: .loading)
    private static let albumStateFailure = AlbumsState(viewState: .failure)
    private static let albumStateDataAvailable = AlbumsState(
        viewState: .dataAvailable,
        cache: [
            1: .dataAvailable([
                .init(albumID: 1, id: 1, title: "Birds", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 2, title: "Birds long name", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 3, title: "Birds with beautiful wings", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 4, title: "Birdemic", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 5, title: "Birds II", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 6, title: "Birds long name II", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 7, title: "Birds with beautiful wings II", url: url, thumbnailURL: url),
                .init(albumID: 1, id: 8, title: "Birdemic II", url: url, thumbnailURL: url)
                
            ], Preview.user(5, "Larry"))
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
