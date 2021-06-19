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
    var bottomViewFrame: CGRect
    var totalHeight: CGFloat
}

struct Constants {
    static let cardInsets = UIEdgeInsets(top: 0, left: 8, bottom: 8, right: 12)
    static let topViewHeight : CGFloat = 36.0
    static let postLabelInsets = UIEdgeInsets(top: 8 + Constants.topViewHeight + 8, left: 8, bottom: 8, right: 8)
    static let postLabelFont = UIFont.systemFont(ofSize: 15)
    static let bottomViewHeight: CGFloat = 44.0
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
        
        let cardViewWidth = screenWidth - Constants.cardInsets.left - Constants.cardInsets.right
        print("CardViewWidth: \(cardViewWidth)")
        
        //MARK:  Работа с postLabelFrame
        
        var postLabelFrame = CGRect(origin: CGPoint(x: Constants.postLabelInsets.left, y: Constants.postLabelInsets.top),
                                    size: CGSize.zero)
        
        if let text = postText, !text.isEmpty {
            let width = cardViewWidth - Constants.postLabelInsets.left - Constants.postLabelInsets.right
            let height = text.height(width: width, font: Constants.postLabelFont)
       
            postLabelFrame.size = CGSize(width: width, height: height)
        }
        
        //MARK:  Работа с attachmentFrame
        
        
        let attachmetTop = postLabelFrame.size == CGSize.zero ? Constants.postLabelInsets.top : postLabelFrame.maxY + Constants.postLabelInsets.bottom
        var attachmentFrame = CGRect(origin: CGPoint(x: 0, y: attachmetTop), size: CGSize.zero)
        
        if let attachment = photoAttachment {
            let ratio = CGFloat(attachment.hight / attachment.weight)
            attachmentFrame.size = CGSize(width: cardViewWidth, height: cardViewWidth * ratio)
            print("ratio:  \(ratio)")
        }
        
        //MARK:  Работа с bottomViewFrame
        
        let bottomViewTop = max(postLabelFrame.maxY, attachmentFrame.maxY)
        let bottomViewFrame = CGRect(origin: CGPoint(x: 0, y: bottomViewTop), size: CGSize(width: cardViewWidth, height: Constants.bottomViewHeight))
        
        //MARK:  Работа с totalHeight
        let totalHeight = bottomViewFrame.maxY + Constants.cardInsets.bottom
        
        return Sizes(postLabelFrame: postLabelFrame,
                     attachmentFrame: attachmentFrame,
                     bottomViewFrame: bottomViewFrame,
                     totalHeight: totalHeight)
    }
}
