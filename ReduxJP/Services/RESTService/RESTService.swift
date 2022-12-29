//
//  RESTService.swift
//  ReduxJP
//
//  Created by Luiz Ramos on 12/27/22.
//

import Foundation

final class RESTService: RESTServiceable {
    private let network: NetworkServiceable
    
    init(network: NetworkServiceable) {
        self.network = network
    }
    
    func fetchUsers() async -> Result<[User], RESTError> {
        await fetch(stringUrl: Constants.Users.all())
    }
    
    func fetchAlbums() async -> Result<[Album], RESTError> {
        await fetch(stringUrl: Constants.Albums.all())
    }
    
    func fetchPhotos(albumID: String) async -> Result<[Photo], RESTError> {
        await fetch(stringUrl: Constants.Photos.with(albumID: albumID))
    }
    
    func fetchUser(userID: String) async -> Result<User, RESTError> {
        await fetch(stringUrl: Constants.Users.with(id: userID))
    }
    
    func fetchUserTodos(userID: String) async -> Result<[Todo], RESTError> {
        await fetch(stringUrl: Constants.Todos.with(userID: userID))
    }
    
    /// Exploits the regularity of the API for fetching items via GET requests
    private func fetch<T: Decodable>(stringUrl: String) async -> Result<T, RESTError> {
        guard let url = URL(string: stringUrl) else {
            Log.restService.e("Bad URL \(stringUrl)")
            return .failure(.badRequest)
        }
        
        do {
            let decoded: T = try await network.perform(request: NetworkRequest(method: .get, url: url))
            Log.restService.i("Success fetching item")
            return .success(decoded)
        } catch {
            Log.restService.e("Failed to fech item \(error)")
            return .failure(.badResponse)
        }
    }
}
