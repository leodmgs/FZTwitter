//
//  FZTweet.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/18/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import Swifter

struct FZTweet {
    
    var text: String
    var mediaUrl: URL?
    var user: FZUser?
    
    init(json: JSON) {
        self.text = json["text"].string!
        if let urlString = json["extended_entities"]["media"][0]["media_url"].string {
            self.mediaUrl = URL(string: urlString)
        }
        self.user = FZUser(json: json["user"])
    }
    
}
