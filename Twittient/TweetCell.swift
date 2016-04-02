//
//  TestCell.swift
//  Twittient
//
//  Created by TriNgo on 3/29/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

@objc protocol TweetCellDelegate:class{
    optional func tweetCell(onReplyClicked tweetCell: TweetCell)
    optional func tweetCell(onRetweetClicked tweetCell: TweetCell)
    optional func tweetCell(onLikeClicked tweetCell: TweetCell)
}

class TweetCell: UITableViewCell {
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var screenNameLabel: UILabel!
    @IBOutlet weak var timeagoLabel: UILabel!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetButton: UIButton!
    
    weak var delegate: TweetCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        avatar.layer.cornerRadius = 3.0
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
