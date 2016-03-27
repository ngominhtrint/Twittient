//
//  TweetCell.swift
//  Twittient
//
//  Created by TriNgo on 3/25/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate:class{
    optional func tweetCell(onReplyClicked tweetCell: TweetCell)
    optional func tweetCell(onRetweetClicked tweetCell: TweetCell)
    optional func tweetCell(onLikeClicked tweetCell: TweetCell)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var avatarImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var timeAgoLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    
    weak var delegate: TweetCellDelegate?
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatarImageView.layer.cornerRadius = 3.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    @IBAction func onReplyClicked(sender: UIButton) {
        delegate?.tweetCell!(onReplyClicked: self)
    }
    
    @IBAction func onRetweetClicked(sender: UIButton) {
        delegate?.tweetCell!(onRetweetClicked: self)
    }

    @IBAction func onLikeClicked(sender: UIButton) {
        delegate?.tweetCell!(onLikeClicked: self)
    }
    
    
}
