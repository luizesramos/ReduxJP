//
//  UsersState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct UsersState: ReduxState {
    var users: [User] = .init()
}
