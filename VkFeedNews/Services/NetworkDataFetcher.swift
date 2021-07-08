//
//  NetworkDataFetcher.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//

import Foundation


protocol DataFetcher {
    func getFeed(respose: @escaping (FeedResponse?) -> Void)
    
    func getUser(respose: @escaping (UserResponse?) -> Void)
}

struct NetworkDataFetcher : DataFetcher {
    
    private let authService: AuthService
    let networking : Networking
    
    init(networking: Networking, authService: AuthService = SceneDelegate.shared().authService) {
        self.networking = networking
        self.authService = authService
    }
    
    func getUser(respose: @escaping (UserResponse?) -> Void) {
        
        guard let userID = authService.userId else { return }
        let params = [ "user_ids" : userID, "fields" : "photo_100"]
        networking.request(path: APIStruct.user, params: params) { (data, error) in
            if let error = error {
                print("Error received requsting data: \(error.localizedDescription)")
                respose(nil)
            }
            
            let decoded = self.decodeJSON(type: UserResponseWrapped.self, from: data)
            respose(decoded?.response.first)
        }

    }
    
    func getFeed(respose: @escaping (FeedResponse?) -> Void) {
        let params = ["filters" : "post, foto"]
        networking.request(path: APIStruct.newsFeed, params: params) { (data, error) in
            if let error = error {
                print("Error received requsting data: \(error.localizedDescription)")
                respose(nil)
            }
            
            let decoded = self.decodeJSON(type: FeedResponseWrapped.self, from: data)
            respose(decoded?.response)
            
        }
    }
    
    private func decodeJSON<T: Decodable>(type: T.Type, from: Data?) -> T? {
        
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase
        guard let data = from, let response = try? decoder.decode(type.self, from: data) else { return nil}
        return response
        
    }
}
