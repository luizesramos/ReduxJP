//
//  PreviewHelper.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/28/22.
//

import Foundation

enum Preview {
    
    static func user(_ id: UInt64, _ name: String) -> User {
        let username = name.lowercased().replacingOccurrences(of: " ", with: "")
        return User(id: id,
                    name: name,
                    username: username,
                    email: "\(username)@a.com",
                    address: address,
                    phone: "555-555-5555",
                    website: "www.\(username).com",
                    company: company)
    }
    
    static let address = Address(street: "A",
                                 suite: "B",
                                 city: "C",
                                 zipcode: "D",
                                 geo: geo)
    
    static let geo = Geo(lat: "1.11", lng: "2.22")
    
    static let company = Company(name: "Mock Inc.",
                                 catchPhrase: "You can't see me",
                                 bs: "None")
}
