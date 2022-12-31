//
//  AlbumsView.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/30/22.
//

import SwiftUI

struct AlbumsView: View {
    @EnvironmentObject var store: Store<AppState>
    
    private struct Props {
        var viewState: AlbumsViewState
        var albums: [Album]
        var fetchAlbums: () -> Void
    }
    
    private func map(albumsState: AlbumsState) -> Props {
        Props(viewState: albumsState.viewState,
              albums: albumsState.albums,
              fetchAlbums: { store.dispatch(action: FetchAlbums()) })
    }
    
    private var props: Props {
        map(albumsState: store.state.albumsState)
    }
    
    var body: some View {
        NavigationStack {
            Group {
                switch props.viewState {
                case .loading:
                    loadingView
                case .failure:
                    failureView
                case .dataAvailable:
                    dataAvailableView
                }
            }
            .navigationTitle("Albums")
            .toolbar { toolbar }
        }
        
        .onAppear {
            props.fetchAlbums()
        }
    }
    
    var loadingView: some View {
        ProgressView()
    }

    var failureView: some View {
        VStack {
            Text("Unable to load. Please wait then try again.")
                .multilineTextAlignment(.center)
                .padding()
            Button("Retry") {
                props.fetchAlbums()
            }
        }

    }
    
    @ViewBuilder
    var dataAvailableView: some View {
        List(props.albums, id: \.id) { item in
            NavigationLink(value: item) {
                HStack {
                    Image(systemName: "photo.fill.on.rectangle.fill")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                        .opacity(0.6)
                        .frame(width: 30, height: 30)
                    Text(item.title)
                }
            }
        }
        .listStyle(.plain)
        .navigationDestination(for: Album.self) { item in
            AlbumPhotosView(item: item)
                .environmentObject(store)
        }
        .refreshable {
            Log.app.i("Refresh albumx")
            props.fetchAlbums()
        }
    }
    
    @ToolbarContentBuilder
    var toolbar: some ToolbarContent {
        ToolbarItem {
            Button("About", action: {})
        }
    }
}

struct AlbumsView_Previews: PreviewProvider {
    private static let albumStateLoading = AlbumsState(viewState: .loading)
    private static let albumStateFailure = AlbumsState(viewState: .failure)
    private static let albumStateDataAvailable = AlbumsState(
        viewState: .dataAvailable,
        albums: [
            Album(userID: 5, id: 1, title: "Test"),
            Album(userID: 5, id: 2, title: "Test2"),
            Album(userID: 5, id: 3, title: "Test3")
        ]
    )
    
    static var previews: some View {
        AlbumsView()
            .environmentObject(Store<AppState>(state: .init(albumsState: albumStateLoading),
                                               reducer: appReducer,
                                               midlewares: []))
        
        AlbumsView()
            .environmentObject(Store<AppState>(state: .init(albumsState: albumStateFailure),
                                               reducer: appReducer,
                                               midlewares: []))
        
        AlbumsView()
            .environmentObject(Store<AppState>(state: .init(albumsState: albumStateDataAvailable),
                                               reducer: appReducer,
                                               midlewares: []))
    }
}
