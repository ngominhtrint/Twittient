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
    @IBOutlet weak var retweetButton: UIButton!

    var tweet: Tweet?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.layer.cornerRadius = 3.0
        
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
        
        let isRetweeted = tweet!.retweeted
        if isRetweeted {
            let image = UIImage(named: "retweeted.png")! as UIImage
            retweetButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "retweet.png")! as UIImage
            retweetButton.setImage(image, forState: .Normal)
        }

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReplyClicked(sender: UIButton) {

    }
    
    @IBAction func onRetweetClicked(sender: UIButton) {
        let id = tweet?.id as! String
        let isRetweeted = (tweet?.retweeted)! as Bool
        let retweetEnum: TwitterClient.Retweet
        
        if isRetweeted {
            retweetEnum = TwitterClient.Retweet.Unretweet
        } else {
            retweetEnum = TwitterClient.Retweet.Retweet
        }
        
        TwitterClient.shareInstance.retweet(id, retweet: retweetEnum, success: { (tweet: Tweet) -> () in
                self.tweet = tweet
                self.showData()
            }) { (error: NSError) -> () in
            print("\(error)")
        }
    }
    
    @IBAction func onLikeClicked(sender: UIButton) {
        let id = tweet?.id as! String
        let isFavorite = (tweet?.favorited)! as Bool
        let favoriteEnum: TwitterClient.Favorite
        if isFavorite {
            favoriteEnum = TwitterClient.Favorite.Unlike
        } else {
            favoriteEnum = TwitterClient.Favorite.Like
        }

        TwitterClient.shareInstance.favorite(id, favorite: favoriteEnum, success: { (tweet: Tweet) -> () in
            self.tweet = tweet
            self.showData()
        }) { (error: NSError) -> () in
            print("\(error)")
        }
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
