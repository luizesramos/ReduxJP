//
//  ReduxJPApp.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import SwiftUI

@main
struct ReduxJPApp: App {
    private let restService: RESTServiceable
    private let store: Store<AppState>

    init () {
        restService = RESTService(network: NetworkService())
        self.store = .init(state: AppState(), reducer: appReducer, midlewares: [
            albumsMiddleware(service: restService),
            usersMiddleware(service: restService)
        ])
    }
    
    var body: some Scene {
        WindowGroup {
            AlbumsView()
                .environmentObject(store)
        }
    }
}

extension Log {
    static var app = Logger(context: "App")
}
