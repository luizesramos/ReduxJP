//
//  AppReducer.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

func appReducer(state: AppState, action: ReduxAction) -> AppState {
    var state = state
    
    state.usersState = usersReducer(state: state.usersState, action: action)
    // Add reducers
    
    return state
}
