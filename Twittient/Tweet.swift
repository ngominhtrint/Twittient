//
//  Tweet.swift
//  Twittient
//
//  Created by TriNgo on 3/24/16.
//  Copyright © 2016 TriNgo. All rights reserved.
//

import UIKit

class Tweet: NSObject {
    
    var id: NSString?
    var text: NSString?
    var timeStamp: NSDate?
    var retweetCount: Int = 0
    var favoritesCount: Int = 0
    var profileImageUrl: NSURL?
    var name: NSString?
    var screenName: NSString?
    var favorited: Bool = false
    var retweeted: Bool = false
    var inReplyToUserId: NSString?
    
    override init() {
        
    }
    
    init(dictionary: NSDictionary){
        id = dictionary["id_str"] as? String
        text = dictionary["text"] as? String
        
        retweetCount = (dictionary["retweet_count"] as? Int) ?? 0
        favoritesCount = (dictionary["favorite_count"] as? Int) ?? 0
        
        let timeStampString = dictionary["created_at"] as? String
        if let timeStampString = timeStampString {
            let formatter = NSDateFormatter()
            formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
            timeStamp = formatter.dateFromString(timeStampString)
        }
        
        favorited = (dictionary["favorited"] as? Bool)!
        retweeted = (dictionary["retweeted"] as? Bool)!
        inReplyToUserId = dictionary["in_reply_to_user_id"] as? String
        
        let user = User.init(dictionary: dictionary["user"] as! NSDictionary)
        profileImageUrl = user.profileUrl
        name = user.name
        screenName = user.screenName
        
    }
    
    class func tweetsWithArray(dictionaries: [NSDictionary]) -> [Tweet]{
        var tweets = [Tweet]()
        
        for dictionary in dictionaries{
            let tweet = Tweet(dictionary: dictionary)
            tweets.append(tweet)
        }
        
        return tweets
    }
    
}
