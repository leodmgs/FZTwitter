//
//  FZTweetCell.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/22/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit

class FZTweetCell: UICollectionViewCell {
    
    // MARK: Attributes
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var userInfo: UILabel!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var tweetText: UITextView!
    @IBOutlet var thumbnailImageView: UIImageView!
    @IBOutlet var tweetOptionsStackView: UIStackView!
    @IBOutlet var tweetOption: UIButton!
    @IBOutlet var separatorLine: UIView!
    
    @IBOutlet var commentButton: FZTweetOptionButton!
    @IBOutlet var retweetButton: FZTweetOptionButton!
    @IBOutlet var likeButton: FZTweetOptionButton!
    @IBOutlet var shareButton: FZTweetOptionButton!
    
    var isLiked = false
    var isRetweeted = false
    
    // MARK: Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        
        profileImage.layer.cornerRadius = 24
        profileImage.clipsToBounds = true
        
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.image = UIImage(named: "media_img")
        
    }
    
    func setTimeElapsed(_ strTime: String) {
        timeElapsedLabel.attributedText = attributedTimeElapsed(for: strTime)
    }
    
    func setUserInfoLabel(_ name: String, _ isVerified: Bool, _ username: String) {
        userInfo.attributedText = attributedUserInfo(name, isVerified, username)
    }
    
    private func attributedTimeElapsed(for strTime: String) -> NSMutableAttributedString {
        let timeElapsed = NSMutableAttributedString()
        timeElapsed.append(NSAttributedString(string: "· \(strTime)", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.47, blue: 0.52, alpha: 1)]))
        return timeElapsed
    }
    
    private func attributedUserInfo(_ name: String, _ isVerified: Bool, _ username: String) -> NSMutableAttributedString {
        let userInfoAttr = NSMutableAttributedString()
        
        userInfoAttr.append(NSAttributedString(string: "\(name) ", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 15)!]))
        
        if isVerified {
            let verifiedImage = NSTextAttachment()
            verifiedImage.image = UIImage(named: "verified_profile")
            verifiedImage.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            let imageString = NSAttributedString(attachment: verifiedImage)
            userInfoAttr.append(imageString)
        }
        
        userInfoAttr.append(NSAttributedString(string: " \(username)", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.47, blue: 0.52, alpha: 1)]))
        
        return userInfoAttr
    }
    
    
    // MARK: Actions
    
    @IBAction func onComment(_ sender: Any) {
        // TODO
        let animation = animationForTweetOption()
        commentButton.layer.add(animation, forKey: "opacity")
    }
    
    @IBAction func onRetweet(_ sender: Any) {
        if isRetweeted {
            retweetButton.iconImage = UIImage(named: "retweet_ic")
            isRetweeted = false
        } else {
            retweetButton.iconImage = UIImage(named: "retweet_ic_on")
            isRetweeted = true
        }
        let animation = animationForTweetOption()
        retweetButton.layer.add(animation, forKey: "opacity")
    }
    
    @IBAction func onLike(_ sender: Any) {
        if isLiked {
            likeButton.iconImage = UIImage(named: "like_ic")
            isLiked = false
        } else {
            likeButton.iconImage = UIImage(named: "like_ic_on")
            isLiked = true
        }
        let animation = animationForTweetOption()
        likeButton.layer.add(animation, forKey: "opacity")
    }
    
    @IBAction func onShare(_ sender: Any) {
        // TODO
        let animation = animationForTweetOption()
        shareButton.layer.add(animation, forKey: "opacity")
    }
    
    private func animationForTweetOption() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 1.1
        animation.duration = 0.8
        animation.speed = 8
        animation.autoreverses = true
        return animation
    }
}
