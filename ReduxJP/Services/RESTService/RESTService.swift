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
        guard let url = URL(string: Constants.Users.allUsers()) else {
            Log.restService.e("Bad URL \(Constants.Users.allUsers())")
            return .failure(.badRequest)
        }
        
        do {
            let users: UsersResponse = try await network.perform(request: NetworkRequest(method: .get, url: url))
            Log.restService.i("Success fetching users")
            return .success(users)
        } catch {
            Log.restService.e("Failed to fech users \(error)")
            return .failure(.badResponse)
        }
    }
    
    func fetchUserAlbums(userID: String) async -> Result<[Album], RESTError> {
        .failure(.badResponse)
    }
    
    func fetchUserTodos(userID: String) async -> Result<[Todo], RESTError> {
        .failure(.badResponse)
    }
}
