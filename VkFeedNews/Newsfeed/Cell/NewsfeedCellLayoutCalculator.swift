//
//  NewsfeedCellLayoutCalculator.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 10.06.2021.
//

import UIKit


struct Sizes : FeedCellSizes {

    var postLabelFrame: CGRect
    var attachmentFrame: CGRect
    var bottomView: CGRect
    var totalHeight: CGFloat
}


protocol FeedCellLayOutCalculatorProtocol {
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttechmentViewModel? ) -> FeedCellSizes
}

final class NewsfeedCellLayoutCalculator : FeedCellLayOutCalculatorProtocol {
    
    private let screenWidth : CGFloat
    
    init(screenWidth: CGFloat = min(UIScreen.main.bounds.width, UIScreen.main.bounds.height)) {
        self.screenWidth = screenWidth
    }
    
    func sizes(postText: String?, photoAttachment: FeedCellPhotoAttechmentViewModel?) -> FeedCellSizes {
        return Sizes(postLabelFrame: CGRect.zero,
                     attachmentFrame: CGRect.zero,
                     bottomView: CGRect.zero,
                     totalHeight: 300)
    }
}
