//
//  ReduxJPApp.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import SwiftUI

@main
struct ReduxJPApp: App {
    private let store: Store<AppState> = .init(state: AppState(), reducer: appReducer, midlewares: [])
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(store)
        }
    }
}
