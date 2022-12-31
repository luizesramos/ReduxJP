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
    
    static let imageUrl = URL(string: "https://images.unsplash.com/photo-1580275595586-1c706a501b57?ixlib=rb-4.0.3&ixid=MnwxMjA3fDB8MHxzZWFyY2h8Mnx8ZnJlZSUyMGJpcmR8ZW58MHx8MHx8&w=1000&q=80")!

    static func photoList(itemCount: Int, albumId: AlbumID = 1) -> [Photo] {
        let titles = [ "Birds", "Birds long name", "Birds with beautiful wings", "Birdemic", "Birds of a feather"]
        
        return (0..<itemCount).reduce(into: []) { partialResult, index in
            let item = Photo(albumID: albumId,
                             id: PhotoID(index),
                             title: titles.randomElement()!,
                             url: imageUrl,
                             thumbnailURL: imageUrl)
            partialResult.append(item)
        }
    }
    
}
