//
//  FeedViewController.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 05.06.2021.
//

import UIKit

class FeedViewController: UIViewController {
    
    private let networkService = NetworkService()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        view.backgroundColor = .systemBlue
        networkService.request(path: "/method/newsfeed.get", params: ["":""]) { (_, _) in
            return
        }
    }
    
    
    
}
