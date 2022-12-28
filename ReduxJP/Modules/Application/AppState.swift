//
//  AppState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct AppState: ReduxState {
    var albumsState: AlbumsState = .init()
    var usersState: UsersState = .init()
    var todosState: TodosState = .init()
}
