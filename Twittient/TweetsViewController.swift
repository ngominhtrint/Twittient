//
//  TweetsViewController.swift
//  Twittient
//
//  Created by TriNgo on 3/24/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import MBProgressHUD

class TweetsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var tweets: [Tweet]!
    var isFirstLoading : Bool = true
    var refreshControl : UIRefreshControl!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.refreshControl = UIRefreshControl()
        self.refreshControl.addTarget(self, action: "loadDataFromNetwork:", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControl, atIndex: 0)
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = 300
        tableView.rowHeight = UITableViewAutomaticDimension
        
        dispatch_async(dispatch_get_main_queue()) {
            self.loadDataFromNetwork(self.refreshControl)
        }
    }
    
    func loadDataFromNetwork(refreshControl: UIRefreshControl) {
        if isFirstLoading {
            MBProgressHUD.showHUDAddedTo(self.view, animated: true)
            isFirstLoading = false
        }
        
        TwitterClient.shareInstance.homeTimeLine({ (tweets:[Tweet]) -> () in
            self.tweets = tweets
            self.tableView.reloadData()
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            refreshControl.endRefreshing()
        }) { (error:NSError) -> () in
            print(error.localizedDescription)
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            refreshControl.endRefreshing()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onLogoutClicked(sender: UIBarButtonItem) {
        displayAlert("Are you sure to sign out?")
    }

    func displayAlert(message: String) {
        let alertController = UIAlertController(title: "Sign Out", message: message, preferredStyle: .Alert)
        
        let OKAction = UIAlertAction(title: "OK", style: .Default) { (action) in
            TwitterClient.shareInstance.logout()
        }
        let CancelAction = UIAlertAction(title: "Cancel", style: .Default) { (action) in
        }
        
        alertController.addAction(OKAction)
        alertController.addAction(CancelAction)
        presentViewController(alertController, animated: true) {
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        let cell = sender as! UITableViewCell
        let indexPath = tableView.indexPathForCell(cell)
        let tweet = tweets[indexPath!.row]
        
        let tweetDetailViewController = segue.destinationViewController as! TweetDetailViewController
        tweetDetailViewController.tweet = tweet
    }

}

extension TweetsViewController: UITableViewDelegate, UITableViewDataSource, TweetCellDelegate {
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets?.count ?? 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.delegate = self
        cell.selectionStyle = .None
        
        let tweet = tweets[indexPath.row]
        
        cell.avatarImageView.setImageWithURL(tweet.profileImageUrl!)
        cell.nameLabel.text = tweet.name as? String
        cell.tagLabel.text = "@\(tweet.screenName as! String)"
        cell.timeAgoLabel.text = timeAgoSince(tweet.timeStamp!)
        cell.descriptionLabel.text = "\(tweet.text)"
        
        let isFavorited = tweet.favorited
        if isFavorited {
            let image = UIImage(named: "like.png")! as UIImage
            cell.likeButton.setImage(image, forState: .Normal)
        } else {
            let image = UIImage(named: "unlike.png")! as UIImage
            cell.likeButton.setImage(image, forState: .Normal)
        }
        
        return cell
    }
    
    func tweetCell(onReplyClicked tweetCell: TweetCell) {
        print("onReplyClicked \(getPosition(tweetCell))")
    }
    
    func tweetCell(onRetweetClicked tweetCell: TweetCell) {
        print("onRetweetClicked \(getPosition(tweetCell))")
    }
    
    func tweetCell(onLikeClicked tweetCell: TweetCell) {
        print("onLikeClicked \(getPosition(tweetCell))")
    }
    
    func getPosition(tweetCell: TweetCell) -> Int{
        let indexPath = tableView.indexPathForCell(tweetCell)
        return indexPath!.row
    }
}





























