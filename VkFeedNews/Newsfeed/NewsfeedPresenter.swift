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
    var cellLauoutCalculator : FeedCellLayOutCalculatorProtocol = NewsfeedCellLayoutCalculator()
    
    
    
    let dateFormatrer : DateFormatter = {
        let dt = DateFormatter()
        dt.locale = Locale(identifier: "ru_RU")
        dt.dateFormat = "d MMM 'в' HH:mm"
        return dt
    }()
    
    func presentData(response: Newsfeed.Model.Response.ResponseType) {
        
        switch response {
        
        case .presentNewsfeed(let feed, let revealdedPostIds):
            
            print("\(revealdedPostIds)")
            
            let cells = feed.items.map { (feedItem) in
                cellViewModel(from: feedItem, profile: feed.profiles, groups: feed.groups, revealdedPostIds: revealdedPostIds)
            }
            
            let feedViewModel = FeedViewModel.init(cells: cells)
            print(".presentNewsfeed presenter")
            viewController?.displayData(viewModel:
                                            Newsfeed.Model.ViewModel.ViewModelData.displayNewsfeed(feedViewModel: feedViewModel))
        case .presentUserInfo(user: let user):
            let userViewModel = UserViewModel.init(photoUrlString: user?.photo100)
            viewController?.displayData(viewModel: Newsfeed.Model.ViewModel.ViewModelData.displayUser(userViewModel: userViewModel))
        }
        
    }
    
    private func cellViewModel(from feedItem: FeedItem, profile: [Profile], groups: [Group], revealdedPostIds : [Int]) -> FeedViewModel.Cell {
        
        let profile = self.profile(for: feedItem.sourceId, profiles: profile , groups: groups)
        let photoAttachments = self.photoAttachments(feedItem: feedItem)
        let date = Date(timeIntervalSince1970: feedItem.date)
        let dateTitle = dateFormatrer.string(from: date)
        
        
        let isFullSized = revealdedPostIds.contains { (postId) -> Bool in
            return postId == feedItem.postId
        }
        
        //        let isFullSized = revealdedPostIds.contains(feedItem.postId)
        
        let sizes = cellLauoutCalculator.sizes(postText: feedItem.text, photoAttachments: photoAttachments, isFullSizedPost: isFullSized)
        let postText = feedItem.text?.replacingOccurrences(of: "<br>", with: "\n")
        
        return FeedViewModel.Cell.init(postId: feedItem.postId,
                                       iconUrlString: profile.photo,
                                       name: profile.name,
                                       date: dateTitle,
                                       text: postText,
                                       likes: formattedCounter(feedItem.likes?.count),
                                       comments: formattedCounter(feedItem.comments?.count),
                                       shares: formattedCounter(feedItem.reposts?.count),
                                       views: formattedCounter(feedItem.views?.count),
                                       photoAttechments: photoAttachments,
                                       sizes: sizes)
        
    }
    
    
    private func profile(for sourseId: Int, profiles: [Profile], groups: [Group]) -> ProfileRepresetable {
        
        let profilesOrGroups : [ProfileRepresetable] = sourseId >= 0 ? profiles : groups
        let normalSoutceId  = sourseId > 0 ? sourseId : -sourseId
        let profileRepresetable = profilesOrGroups.first { (myProfileRepresetable) -> Bool in
            myProfileRepresetable.id == normalSoutceId
        }
        return profileRepresetable!
        
        
    }
    
    private func formattedCounter(_ counter: Int?) -> String? {
        guard let counter = counter , counter > 0 else { return nil }
        
        var counterString = String(counter)
        
        if 4...6 ~= counterString.count {
//            counterString = String(counter / 1000) + "K"
            counterString = String(counterString.dropLast(3)) + "K"
        } else if counterString.count > 6 {
            counterString = String(counterString.dropLast(6)) + "M"
        }
        
        return counterString
        
    }
    
    private func photoAttachment(feedItem: FeedItem) -> FeedViewModel.FeedCellPhotoAttechment? {
        
        guard let photos = feedItem.attachments?.compactMap({ (attachment) in
            attachment.photo
        }), let firstPhoto = photos.first else {
            return nil
            
        }
        return FeedViewModel.FeedCellPhotoAttechment.init(photoUrlString: firstPhoto.srcBIG,
                                                          width: firstPhoto.width,
                                                          height: firstPhoto.height)
    }
    
    private func photoAttachments(feedItem: FeedItem) -> [FeedViewModel.FeedCellPhotoAttechment] {
        guard let attachments = feedItem.attachments else { return [] }
        
        
        return attachments.compactMap { (attachment) -> FeedViewModel.FeedCellPhotoAttechment? in
            guard let photo = attachment.photo else { return nil }
            
            return FeedViewModel.FeedCellPhotoAttechment.init(photoUrlString: photo.srcBIG,
                                                              width: photo.width,
                                                              height: photo.height)
            
        }
    }
}
