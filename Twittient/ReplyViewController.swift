//
//  ReplyViewController.swift
//  Twittient
//
//  Created by TriNgo on 3/26/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class ReplyViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var replyTextField: UITextField!
    
    var tweet: Tweet?
    var isReplyMessage: Bool = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        replyTextField.delegate = self
        replyTextField.becomeFirstResponder()
        
        avatarImage.layer.cornerRadius = 3.0
        
        showData()
    }

    func showData() {
        if tweet != nil {
            nameLabel.text = tweet!.name as? String
            tagLabel.text = tweet!.screenName as? String
            avatarImage.setImageWithURL(tweet!.profileImageUrl!)
        } else {
            nameLabel.text = User.currentUser?.name as? String
            tagLabel.text = User.currentUser?.screenName as? String
            avatarImage.setImageWithURL((User.currentUser?.profileUrl)!)
        }
        
        if isReplyMessage {
            replyTextField.text = "@\(tweet?.screenName as! String) "
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetClicked(sender: UIBarButtonItem) {

        let status = replyTextField.text

        if isReplyMessage {
            var id: String  = ""
            if tweet!.id != nil {
                id = tweet!.id as! String
            }
            TwitterClient.shareInstance.statusUpdate(status!, inReplyToStatusId: id, success: { (tweet:Tweet) -> () in
                print("Tweet: \(tweet)")
                }) { (error: NSError) -> () in
                    print("Error: \(error)")
            }
        } else {
            TwitterClient.shareInstance.statusUpdate(status!, success: { (tweet:Tweet) -> () in
                print("Tweet: \(tweet)")
            }) { (error: NSError) -> () in
                print("Error: \(error)")
            }
        }
        
        clearTweetMessage()
        goBack()
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func clearTweetMessage() {
        replyTextField.text = ""
    }
    
    func goBack() {
        navigationController?.popViewControllerAnimated(true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
