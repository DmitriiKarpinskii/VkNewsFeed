//
//  NetworkService.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 05.06.2021.
//

import Foundation

final class NetworkService {
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    func getFeed() {
        var components = URLComponents()
        
//        https://api.vk.com/method/users.get?user_ids=210700286&fields=bdate&access_token=533bacf01e11f55b536a565b57531ac114461ae8736d6506a3&v=5.131
        
                
        
        guard let token = authService.token else { return }
        let params = ["filters" : "post,photo"]
        var allParams : [String : String] = params
        allParams["access_token"] = token
        allParams["v"] = APIStruct.version
        
        components.scheme = APIStruct.scheme
        components.host = APIStruct.host
        components.path = APIStruct.newsFeed
        components.queryItems = allParams.map { URLQueryItem(name: $0, value: $1) }
        
        let url = components.url!
        print(url)
    }

}

    
