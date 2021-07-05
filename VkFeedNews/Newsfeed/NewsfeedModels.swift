//
//  NewsfeedModels.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

enum Newsfeed {
   
  enum Model {
    struct Request {
      enum RequestType {
        case getNewsfeed
        case revealPostIds(postId: Int)
      }
    }
    struct Response {
      enum ResponseType {
        case presentNewsfeed(feed: FeedResponse, revealdedPostIds : [Int])
      }
    }
    struct ViewModel {
      enum ViewModelData {
        case displayNewsfeed(feedViewModel: FeedViewModel)
      }
    }
  }
}

struct FeedViewModel {
    
    let cells: [Cell]
    
    struct Cell: FeedCellViewModel {

        var postId : Int        
        var iconUrlString: String
        var name: String
        var date: String
        var text: String?
        var likes: String?
        var comments: String?
        var shares: String?
        var views: String?
        var photoAttechments: [FeedCellPhotoAttechmentViewModel]
        var sizes: FeedCellSizes
    }
    
    struct FeedCellPhotoAttechment : FeedCellPhotoAttechmentViewModel {
        var photoUrlString: String?
        var width: Int
        var height: Int
    }
}


