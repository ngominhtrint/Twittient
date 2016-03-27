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
    override func viewDidLoad() {
        super.viewDidLoad()

        replyTextField.delegate = self
        replyTextField.becomeFirstResponder()
        
        nameLabel.text = "\(tweet!.name)"
        tagLabel.text = "\(tweet!.screenName)"
        avatarImage.setImageWithURL(tweet!.profileImageUrl!)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onTweetClicked(sender: UIBarButtonItem) {
        clearTweetMessage()
        
        // post reply message
    }
    
    @IBAction func onCancelClicked(sender: AnyObject) {
        navigationController?.popViewControllerAnimated(true)
    }
    
    func clearTweetMessage(){
        replyTextField.text = ""
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
