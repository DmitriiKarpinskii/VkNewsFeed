//
//  NewsfeedInteractor.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedBusinessLogic {
    func makeRequest(request: Newsfeed.Model.Request.RequestType)
}

class NewsfeedInteractor: NewsfeedBusinessLogic {
    
    var presenter: NewsfeedPresentationLogic?
    var service: NewsfeedService?
    
    func makeRequest(request: Newsfeed.Model.Request.RequestType) {
        if service == nil {
            service = NewsfeedService()
        }
        
        switch request {
        
        case .getNewsfeed:
            service?.getFeed(complition: { [weak self] (revealedPostIds, feed) in
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostIds: revealedPostIds))
            })
        case .getUser:
            service?.getUser(complition: { [weak self] (user) in
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentUserInfo(user: user))
            })
        case .revealPostIds(postId: let postId):
            service?.revealPostIds(forPostId: postId, complition: { [weak self]  (revealedPostIds, feed) in
                self?.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostIds: revealedPostIds))
            })
        case .getNextBatch:

            self.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentFooterLoader)
            service?.getNexBatch(complition: { (revealedPostIds, feed) in
                self.presenter?.presentData(response: Newsfeed.Model.Response.ResponseType.presentNewsfeed(feed: feed, revealdedPostIds: revealedPostIds))
            })
        }
    }
}
