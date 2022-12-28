//
//  TodosState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct Todo: Codable {
    let userId: String
    let id: String
    let title: String
    let completed: Bool
}

struct TodosState: ReduxState {
    var todos: [Todo]
}
