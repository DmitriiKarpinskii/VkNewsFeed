//
//  NewsfeedCell.swift
//  VkFeedNews
//
//  Created by Dmitry Karpinsky on 08.06.2021.
//

import Foundation
import UIKit

class NewsfeedCell : UITableViewCell {
    
    static let reuseId = "NewsfeedCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var postLabel: UILabel!
    @IBOutlet weak var likesLabel: UIView!
    @IBOutlet weak var commentsLabel: UIView!
    @IBOutlet weak var sharedsLabel: UIView!
    @IBOutlet weak var viewsLabel: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
}
