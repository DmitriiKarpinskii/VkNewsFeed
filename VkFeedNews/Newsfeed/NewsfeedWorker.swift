//
//  NewsfeedWorker.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

class NewsfeedService {
    
    

    var authService: AuthService
    var networkig: Networking
    var fetcher: DataFetcher
    private var newFromInProcess: String?
    
    private var revealedPostIds = [Int]()
    private var feedResponse: FeedResponse?
    
    init() {
        self.authService = SceneDelegate.shared().authService
        self.networkig = NetworkService(authService: authService)
        self.fetcher = NetworkDataFetcher(networking: networkig)
    }
    
    func getUser(complition: @escaping (UserResponse?) -> Void) {
        fetcher.getUser { (userResponse) in
            complition(userResponse)
        }
    }
    
    func getFeed(complition: @escaping ([Int], FeedResponse) -> Void) {
        fetcher.getFeed(nextBatchFrom: nil) { [weak self] (feed) in
            self?.feedResponse = feed
            guard let feedResponse = self?.feedResponse else { return }
            
            complition(self!.revealedPostIds, feedResponse)
        }
    }
    
    func revealPostIds(forPostId postId: Int, complition: @escaping ([Int], FeedResponse) -> Void) {
        revealedPostIds.append(postId)
        guard let feedResponse = self.feedResponse else { return }
        complition(revealedPostIds, feedResponse)
    }
    
    func getNexBatch(complition: @escaping ([Int], FeedResponse) -> Void) {
        newFromInProcess = feedResponse?.nextFrom
        fetcher.getFeed(nextBatchFrom: newFromInProcess) { [weak self] (feed) in
            guard let feed = feed else { return }
            guard self?.feedResponse?.nextFrom != feed.nextFrom else { return }
            
            if self?.feedResponse == nil {
                self?.feedResponse = feed
            } else {
                self?.feedResponse?.items.append(contentsOf: feed.items)
                
                var profiles = feed.profiles
                if let oldProfiles = self?.feedResponse?.profiles {
                    let oldProfilesFiltered = oldProfiles.filter ({ (oldProfile) -> Bool in
                        !feed.profiles.contains(where: { $0.id == oldProfile.id })
                    })
                    
                    profiles.append(contentsOf: oldProfilesFiltered)
                }
                self?.feedResponse?.profiles = profiles
                
                var groups = feed.groups
                if let oldGroups = self?.feedResponse?.groups {
                    let oldGroupsFiltered = oldGroups.filter ({ (oldGroups) -> Bool in
                        !feed.groups.contains(where: { $0.id == oldGroups.id })
                    })
                    
                    groups.append(contentsOf: oldGroupsFiltered)
                }
                self?.feedResponse?.groups = groups
                self?.feedResponse?.nextFrom = feed.nextFrom
            }
            
            guard let feedResponse = self?.feedResponse else { return }
            complition(self!.revealedPostIds, feedResponse)
        }
    }
    


    
    
    
}
