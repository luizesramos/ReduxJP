//
//  UsersState.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

struct User: Codable {
    let id: UserID
    let name: String
    let username: String
    let email: String
    let address: Address
    let phone: String
    let website: String
    let company: Company
}

extension User: Hashable, Equatable {
    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(name)
        hasher.combine(username)
        hasher.combine(email)
        hasher.combine(address.street)
        hasher.combine(phone)
        hasher.combine(website)
        hasher.combine(company.name)
    }
}

struct Address: Codable {
    let street: String
    let suite: String
    let city: String
    let zipcode: String
    let geo: Geo
}

struct Geo: Codable {
    let lat: String
    let lng: String
}

struct Company: Codable {
    let name: String
    let catchPhrase: String
    let bs: String
}

struct Todo: Codable {
    let userID: UserID
    let id: TodoID
    let title: String
    let completed: Bool
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id
        case title
        case completed
    }
}

typealias UserID = UInt64
typealias TodoID = UInt64

struct UsersState: ReduxState {
    var users: [User] = .init()
    var userTodos: [UserID: Todo] = .init()
}
