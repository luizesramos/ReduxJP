//
//  RESTMiddleware.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/28/22.
//

import Foundation

func restMiddleware(service: RESTServiceable) -> Middleware<AppState> {{ state, action, dispatch in
    switch action {
    case is FetchUsers:
        Task {
            switch await service.fetchUsers() {
            case .success(let users):
                dispatch(UpdateUsers(users: users))
            case .failure(let error):
                Log.restService.e(error.localizedDescription)
            }
        }
    default:
        break
    }
}}
