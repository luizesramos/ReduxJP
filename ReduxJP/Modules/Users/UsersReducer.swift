//
//  UsersReducer.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/28/22.
//

import Foundation

func usersReducer(state: UsersState, action: ReduxAction) -> UsersState {
    var state = state
    
    switch action {
    case let a as UpdateUsers:
        state.users = a.users
    default:
        break
    }
    
    return state
}
