//
//  RESTServiceable.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

enum Constants {
    enum Users {
        static func allUsers() -> String {
            "https://jsonplaceholder.typicode.com/users"
        }
        static func user(withID id: String) -> String {
            "https://jsonplaceholder.typicode.com/users/\(id)"
        }
    }
}

enum RESTError: Error {
    case badRequest
    case badStatus(Int)
    case badResponse
}

protocol RESTServiceable {
    func fetchUsers() async -> Result<[User], RESTError>
    func fetchUserAlbums(userID: String) async -> Result<[Album], RESTError>
    func fetchUserTodos(userID: String) async -> Result<[Todo], RESTError>
}

extension Log {
    static let restService = Logger(context: "RESTService")
}
