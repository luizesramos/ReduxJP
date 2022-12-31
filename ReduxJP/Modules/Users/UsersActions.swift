//
//  UsersActions.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/28/22.
//

import Foundation

struct FetchUsers: ReduxAction {}

struct UpdateUsers: ReduxAction {
    let users: [User]
}

struct FetchUser: ReduxAction {
    let id: String
}
