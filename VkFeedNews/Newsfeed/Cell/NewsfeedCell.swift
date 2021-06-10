//
//  NewsfeedCell.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//

import Foundation
import UIKit


protocol FeedCellViewModel {
    var iconUrlString: String { get }
    var name: String { get }
    var date: String { get }
    var text: String? { get }
    var likes: String? { get }
    var comments: String? { get }
    var shares: String? { get }
    var views: String? { get }
    
    
}

class NewsfeedCell : UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: WebImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UILabel!
    @IBOutlet weak var commentsLabel: UILabel!
    @IBOutlet weak var sharedsLabel: UILabel!
    @IBOutlet weak var viewsLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func set(viewModel : FeedCellViewModel) {
        iconImageView.set(imageUrl: viewModel.iconUrlString)
        nameLabel.text = viewModel.name
        dateLabel.text = viewModel.date
        postLabel.text = viewModel.text
        likesLabel.text = viewModel.likes
        commentsLabel.text = viewModel.comments
        sharedsLabel.text = viewModel.shares
        viewsLabel.text =  viewModel.views
    }
    
}
