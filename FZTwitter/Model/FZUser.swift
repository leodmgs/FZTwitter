//
//  FZUser.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/25/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import Swifter

struct FZUser {
    
    var name: String
    var id: String
    var screenName: String
    var description: String
    var createdAt: String
    var urlProfileImage: URL?
    var urlProfileBackgroundImage: URL?
    var verified: Bool
    var followers: Int
    var friends: Int
    var statuses: Double
    var isFollowing: Bool = false
    
    init(json: JSON) {
        self.name = json["name"].string!
        self.id = json["id_str"].string!
        self.screenName = json["screen_name"].string!
        self.description = json["description"].string!
        self.createdAt = json["created_at"].string!
        self.urlProfileImage = URL(string: json["profile_image_url"].string!)
        if json["profile_background_image_url"] != nil {
            self.urlProfileBackgroundImage = URL(string: json["profile_background_image_url"].string!)
        }
        self.verified = json["verified"].bool!
        self.followers = json["followers_count"].integer!
        self.friends = json["friends_count"].integer!
        self.statuses = json["statuses_count"].double!
        if json["following"] != nil {
            self.isFollowing = true
        }
    }
    
}
