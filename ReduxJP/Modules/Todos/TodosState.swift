//
//  TodosState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct Todo: Codable {
    let userID: String
    let id: String
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
        case completed
    }
}

struct TodosState: ReduxState {
    var todos: [Todo] = .init()
}
