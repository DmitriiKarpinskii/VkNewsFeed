//
//  NetworkService.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 05.06.2021.
//

import Foundation

protocol Networking {
    
    func request(path: String, params: [String: String], completion: @escaping (Data?, Error?) -> Void)
}

final class NetworkService : Networking {
    
    
    private let authService: AuthService
    
    init(authService: AuthService = SceneDelegate.shared().authService) {
        self.authService = authService
    }
    
    
    func request(path: String, params: [String : String], completion: @escaping(Data?, Error?) -> Void) {
        guard let token = authService.token else { return }

        var allParams : [String : String] = params
        allParams["v"] = APIStruct.version
        allParams["access_token"] = token
        
        let url = self.url(from: path, params: allParams)
        print(url)
        let request = URLRequest(url: url)
        let task = self.createDataTask(from: request, completion: completion)
        task.resume()
    }

    private func createDataTask(from request: URLRequest, completion: @escaping(Data?, Error?) -> Void) -> URLSessionDataTask
        {
        return URLSession.shared.dataTask(with: request) { (data, response, error) in
            DispatchQueue.main.async {
                completion(data, error)
            }
        }
    }
    
    private func url(from path: String , params: [String: String]) -> URL {
        
        var components = URLComponents()

        components.scheme = APIStruct.scheme
        components.host = APIStruct.host
        components.path = path
        components.queryItems = params.map { URLQueryItem(name: $0, value: $1) }
        return components.url!

    }

}



