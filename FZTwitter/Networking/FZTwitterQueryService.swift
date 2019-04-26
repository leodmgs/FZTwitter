//
//  FZTwitterQueryService.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/25/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import Swifter

class FZTwitterQueryService {
    
    static let shared = FZTwitterQueryService()
    
    private let TWITTER_CONSUMER_KEY = "RU6BDzAoS72sFU6h8U5yfg94K"
    private let TWITTER_CONSUMER_SECRET = "baR0HPTZ2THizotgRM8RmA0hXQzqtdFOIwbK7Iyl64sPgaodZ5"
    
    private let swifterAgent: Swifter!
    
    private init() {
        self.swifterAgent = Swifter(
            consumerKey: TWITTER_CONSUMER_KEY,
            consumerSecret: TWITTER_CONSUMER_SECRET)
    }
    
    func search(query: String, completion: @escaping (Array<FZTweet>?) -> ()) {
        swifterAgent.searchTweet(using: query, count: 20, includeEntities: true, success: { json, error in
            var tweets = Array<FZTweet>()
            tweets = self.items(jsonItems: json)
            completion(tweets)
        }, failure: { error in
            debugPrint("\(error.localizedDescription)")
        })
        
    }
    
    func timeline(for userId: String, completion: @escaping (Array<FZTweet>?) -> ()) {
        swifterAgent.getTimeline(for: UserTag.id(userId), excludeReplies: true, success: { json in
            var tweets = Array<FZTweet>()
            tweets = self.items(jsonItems: json)
            completion(tweets)
        }, failure: { error in
            debugPrint("\(error.localizedDescription)")
        })
    }
    
    private func items(jsonItems: JSON) -> Array<FZTweet> {
        var items = Array<FZTweet>()
        guard let jsonArrayItems = jsonItems.array else { return items }
        for item in jsonArrayItems {
            let tweetData = FZTweet(json: item)
            items.append(tweetData)
        }
        return items
    }
    
}
