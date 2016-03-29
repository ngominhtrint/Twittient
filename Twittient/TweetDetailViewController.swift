//
//  TweetDetailViewController.swift
//  Twittient
//
//  Created by TriNgo on 3/26/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    
    @IBOutlet weak var retweetUserLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var timeStampLabel: UILabel!
    @IBOutlet weak var numberRetweetLabel: UILabel!
    @IBOutlet weak var numberFavoritesLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var avatarImage: UIImageView!

    var tweet: Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        showData()
        
        // Do any additional setup after loading the view.
    }
    
    func showData(){
        nameLabel.text = tweet!.name as? String
        tagLabel.text = tweet!.screenName as? String
        descriptionLabel.text = tweet!.text as? String
        numberRetweetLabel.text = "\(tweet!.retweetCount)"
        numberFavoritesLabel.text = "\(tweet!.favoritesCount)"
        avatarImage.setImageWithURL((tweet!.profileImageUrl)!)
        
        let timeStamp = dateFromString((tweet?.timeStamp)!, format: "dd/MM/yy HH:mm a")
        timeStampLabel.text = "\(timeStamp)"
        
        let isFavorited = tweet!.favorited
        if isFavorited {
            let image = UIImage(named: "like.png")! as UIImage
            likeButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "unlike.png")! as UIImage
            likeButton.setImage(image, forState: .Normal)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReplyClicked(sender: UIButton) {
        
    }
    
    @IBAction func onRetweetClicked(sender: UIButton) {
    
    }
    
    @IBAction func onLikeClicked(sender: UIButton) {
    
    }
    
    func dateFromString(date: NSDate, format: String) -> String {
        let formatter = NSDateFormatter()
        let locale = NSLocale(localeIdentifier: "en_US_POSIX")
        
        formatter.locale = locale
        formatter.dateFormat = format
        
        return formatter.stringFromDate(date)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {

        let replyViewController = segue.destinationViewController as! ReplyViewController
        replyViewController.tweet = self.tweet
        replyViewController.isReplyMessage = true
        print("Reply Tweet")
    }


}
