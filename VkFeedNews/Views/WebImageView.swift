//
//  WebImageView.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 10.06.2021.
//

import Foundation
import UIKit

class WebImageView : UIImageView {
    
    private var currentUrlString: String?
    
    func set(imageUrl: String?) {
        currentUrlString = imageUrl
        
        guard let imageUrl = imageUrl, let url = URL(string: imageUrl) else {
            self.image = nil
            return }
        
        if let cachedResponse = URLCache.shared.cachedResponse(for: URLRequest(url: url)) {
            self.image = UIImage(data: cachedResponse.data)
//            print("from cach")
            return
        }
        
        let dataTask = URLSession.shared.dataTask(with: url) { [weak self] (data, response,error) in
            DispatchQueue.main.async {
                if let data = data, let response = response {
                    self?.handleLoadedImage(data: data, response: response)
//                    print("from internet")
                }
            }
        }
        dataTask.resume()
    }
    
    private func handleLoadedImage(data: Data, response: URLResponse) {
        
        guard let responseURL = response.url else { return }
        let cachedResopnse = CachedURLResponse(response: response, data: data)
        URLCache.shared.storeCachedResponse(cachedResopnse, for: URLRequest(url: responseURL))
        if responseURL.absoluteString == currentUrlString {
            self.image = UIImage(data: data)
        }
    }
}
