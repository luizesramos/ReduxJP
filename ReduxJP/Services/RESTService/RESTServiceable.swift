//
//  RESTServiceable.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

enum Constants {
    enum Users {
        static func all() -> String { "https://jsonplaceholder.typicode.com/users" }
        static func with(id: String) -> String { "https://jsonplaceholder.typicode.com/users/\(id)" }
    }
    enum Albums {
        static func all() -> String { "https://jsonplaceholder.typicode.com/albums" }
    }
    enum Photos {
        static func with(albumID id: String) -> String { "https://jsonplaceholder.typicode.com/photos?albumId=\(id)" }
    }
    enum Todos {
        static func with(userID id: String) -> String { "https://jsonplaceholder.typicode.com/todos?userId=\(id)" }
    }
}

enum RESTError: Error {
    case badRequest
    case badStatus(Int)
    case badResponse
}

protocol RESTServiceable {
    func fetchUsers() async -> Result<[User], RESTError>
    func fetchAlbums() async -> Result<[Album], RESTError>
    func fetchUser(userID: String) async -> Result<User, RESTError>
    func fetchPhotos(albumID: String) async -> Result<[Photo], RESTError>
    func fetchUserTodos(userID: String) async -> Result<[Todo], RESTError>
}

extension Log {
    static let restService = Logger(context: "RESTService")
}
