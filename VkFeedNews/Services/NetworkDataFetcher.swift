//
//  NetworkDataFetcher.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//

import Foundation


protocol DataFetcher {
    func getFeed(respose: @escaping (FeedResponse?) -> Void)
}

struct NetworkDataFetcher : DataFetcher {
    
    let networking : Networking
    
    init(networking: Networking) {
        self.networking = networking
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
