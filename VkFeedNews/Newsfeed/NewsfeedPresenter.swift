//
//  NewsfeedPresenter.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//  Copyright (c) 2021 ___ORGANIZATIONNAME___. All rights reserved.
//

import UIKit

protocol NewsfeedPresentationLogic {
  func presentData(response: Newsfeed.Model.Response.ResponseType)
}

class NewsfeedPresenter: NewsfeedPresentationLogic {
  weak var viewController: NewsfeedDisplayLogic?
    let dateFormatrer : DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
  
  func presentData(response: Newsfeed.Model.Response.ResponseType) {
  
    switch response {
    
    case .presentNewsfeed(let feed):
        
        let cells = feed.items.map { (feedItem) in
            cellViewModel(from: feedItem, profile: feed.profiles, groups: feed.groups)
        }
        
        let feedViewModel = FeedViewModel.init(cells: cells)
        print(".presentNewsfeed presenter")
        viewController?.displayData(viewModel:
                                        Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
    }
    
  }
    
    private func cellViewModel(from feedItem: FeedItem, profile: [Profile], groups: [Group]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profile , groups: groups)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatrer.string(from: date)
        
        return FeedViewModel.Cell.init(iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: feedItem.text,
                                       likes: String(feedItem.likes?.count ?? 0),
                                       comments: String(feedItem.comments?.count ?? 0),
                                       shares: String(feedItem.reposts?.count ?? 0),
                                       views: String(feedItem.views?.count ?? 0))
    }
  
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresetable {
    
        let profilesOrGroups : [ProfileRepresetable] = sourseId >= 0 ? profiles : groups
        let normalSoutceId  = sourseId > 0 ? sourseId : -sourseId
        let profileRepresetable = profilesOrGroups.first { (myProfileRepresetable) -> Bool in
            myProfileRepresetable.id == normalSoutceId
        }
        return profileRepresetable!
        
        
    }
}
