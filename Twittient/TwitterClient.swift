//
//  TwitterClient.swift
//  Twittient
//
//  Created by TriNgo on 3/24/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class TwitterClient: BDBOAuth1SessionManager {
    
    static let shareInstance = TwitterClient(baseURL: NSURL(string: "https://api.twitter.com")!, consumerKey: "lUfkLs6D1qDcGergDpZXPx15Y", consumerSecret: "ctzb3tAsf0H8jskhAKHJ1Y2JHCvfs9QdJXOWFEalaLWHJd1kPy")
    
    enum Favorite {
        case Like
        case Unlike
    }
    
    enum Retweet {
        case Retweet
        case Unretweet
    }
    
    var loginSuccess: (() -> ())?
    var loginFailure: ((NSError) -> ())?
    
    func login(success: () -> (), failure: (NSError) -> ()){
        loginSuccess = success
        loginFailure = failure
        
        self.deauthorize()
        self.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string: "twittient://oauth"), scope: nil, success: {(requestToken: BDBOAuth1Credential!) -> Void in
            print("I got a token")
            
            let url = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
            UIApplication.sharedApplication().openURL(url!)
            
            }) {( error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure!(error)
        }
    }
    
    func logout() {
        
        User.currentUser = nil
        deauthorize()
        
        NSNotificationCenter.defaultCenter().postNotificationName(User.userDidLogoutNotification, object: nil)
    }
    
    func handleOpenUrl(url: NSURL){
        let requestToken = BDBOAuth1Credential(queryString: url.query)
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: requestToken, success: {(accessToken: BDBOAuth1Credential!) -> Void in
            print("I got an access token")
            self.requestSerializer.saveAccessToken(accessToken)
            self.currentAccount({ (user: User) -> () in
                    User.currentUser = user
                    self.loginSuccess?()
                }, failure: { (error: NSError) -> () in
                    self.loginFailure!(error)
                })
            }) {( error: NSError!) -> Void in
                print("error: \(error.localizedDescription)")
                self.loginFailure!(error)
        }

    }
    
    
    // new tweet
    func statusUpdate(status: String, inReplyToStatusId: String? = nil, success: (Tweet) -> (), failure: (NSError) -> ()){
        let params = ["status":status,
            "in_reply_to_user_id": inReplyToStatusId == nil ? "" : inReplyToStatusId! as String]
        
        print("\(params)")
        
        POST("1.1/statuses/update.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
                let tweetDictionary = response as! NSDictionary
                let tweet = Tweet(dictionary: tweetDictionary)
                success(tweet)
            }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
                failure(error)
        })
    
    }
    
    // reply tweet
    func statusRetweet(id: String, status: String, success: (Tweet) -> (), failure: (NSError) -> ()){
        POST("1.1/statuses/retweet/\(id).json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
        
    }
    
    func homeTimeLine(page: Int, success: ([Tweet]) -> (), failure: (NSError) -> ()){
        let itemPaging = page * 20
        let params = [
            "count": itemPaging
        ]
        GET("1.1/statuses/home_timeline.json", parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let dictionaries = response as! [NSDictionary]
            let tweets = Tweet.tweetsWithArray(dictionaries)
            success(tweets)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })

    }
    
    func currentAccount(success: (User) -> (), failure: (NSError) -> ()){
        GET("/1.1/account/verify_credentials.json", parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let userDictionary = response as! NSDictionary
            let user = User(dictionary: userDictionary)
            success(user)
        }, failure: { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        })
        
    }
    
    func favorite(id: String, favorite: Favorite, success: (Tweet) -> (), failure: (NSError) -> ()){
        let params = ["id": id]
        var path: String = ""
        
        switch favorite {
        case .Like:
            path = "/1.1/favorites/create.json"
            break
        case .Unlike:
            path = "/1.1/favorites/destroy.json"
            break
        }
        
        POST(path, parameters: params, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            failure(error)
        }
    }
    
    func retweet(id: String, retweet: Retweet, success: (Tweet) -> (), failure: (NSError) -> ()){
        var path: String = ""
        switch retweet {
        case .Retweet:
            path = "/1.1/statuses/retweet/\(id).json"
            break
        case .Unretweet:
            path = "/1.1/statuses/unretweet/\(id).json"
            break
        }
        
        POST(path, parameters: nil, progress: nil, success: { (task: NSURLSessionDataTask, response: AnyObject?) -> Void in
            let tweetDictionary = response as! NSDictionary
            let tweet = Tweet(dictionary: tweetDictionary)
            success(tweet)
        }) { (task: NSURLSessionDataTask?, error: NSError) -> Void in
            print("\(error)")
        }
    }

    
    
}



