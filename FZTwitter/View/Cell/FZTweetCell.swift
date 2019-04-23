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
        // Disable autoresizing to handle constraints with autolayout
        self.translatesAutoresizingMaskIntoConstraints = false
        profileImage.translatesAutoresizingMaskIntoConstraints = false
        userInfo.translatesAutoresizingMaskIntoConstraints = false
        timeElapsedLabel.translatesAutoresizingMaskIntoConstraints = false
        tweetOption.translatesAutoresizingMaskIntoConstraints = false
        tweetText.translatesAutoresizingMaskIntoConstraints = false
        thumbnailImageView.translatesAutoresizingMaskIntoConstraints = false
        tweetOptionsStackView.translatesAutoresizingMaskIntoConstraints = false
        separatorLine.translatesAutoresizingMaskIntoConstraints = false
        
        activateProfileImageConstraints()
        activateUserInfoConstraints()
        activateTimeElapsedConstraints()
        activateTweetOptionConstraints()
        activateTweetTextConstraints()
        activateThumbnailImageConstraints()
        activateTweetOptionsStackConstraints()
        activateSeparatorLineConstraints()

        setupStackOptions()
        
        profileImage.layer.cornerRadius = 28
        profileImage.clipsToBounds = true
        
        thumbnailImageView.layer.cornerRadius = 12
        thumbnailImageView.clipsToBounds = true
        thumbnailImageView.image = UIImage(named: "media_img")
        
    }
    
    private func activateProfileImageConstraints() {
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 15),
            profileImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 15),
            profileImage.widthAnchor.constraint(equalToConstant: 56),
            profileImage.heightAnchor.constraint(equalToConstant: 56)
            ])
    }
    
    private func activateUserInfoConstraints() {
        NSLayoutConstraint.activate([
            userInfo.topAnchor.constraint(equalTo: profileImage.topAnchor),
            userInfo.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 5)
            ])
    }
    
    private func activateTimeElapsedConstraints() {
        // FIXME: Time elapsed label must have the tweetOption leading as its constraint and the userInfo needs to be broken.
        NSLayoutConstraint.activate([
            timeElapsedLabel.topAnchor.constraint(equalTo: userInfo.topAnchor),
            timeElapsedLabel.leadingAnchor.constraint(equalTo: userInfo.trailingAnchor, constant: 5),
            timeElapsedLabel.trailingAnchor.constraint(lessThanOrEqualTo: tweetOption.leadingAnchor, constant: -5)
            ])
    }
    
    private func activateTweetOptionConstraints() {
        NSLayoutConstraint.activate([
            tweetOption.topAnchor.constraint(equalTo: userInfo.topAnchor),
            tweetOption.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            tweetOption.widthAnchor.constraint(equalToConstant: 20),
            tweetOption.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    private func activateTweetTextConstraints() {
        NSLayoutConstraint.activate([
            tweetText.topAnchor.constraint(equalTo: userInfo.bottomAnchor),
            tweetText.leadingAnchor.constraint(equalTo: userInfo.leadingAnchor, constant: -5),
            tweetText.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15)
            ])
    }
    
    private func activateThumbnailImageConstraints() {
        // FIXME: media container should support some dimensions
        NSLayoutConstraint.activate([
            thumbnailImageView.topAnchor.constraint(equalTo: tweetText.bottomAnchor, constant: 5),
            thumbnailImageView.leadingAnchor.constraint(equalTo: userInfo.leadingAnchor),
            thumbnailImageView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -15),
            thumbnailImageView.heightAnchor.constraint(equalToConstant: 160)
            ])
    }
    
    private func activateTweetOptionsStackConstraints() {
        NSLayoutConstraint.activate([
            // FIXME
            tweetOptionsStackView.leadingAnchor.constraint(equalTo: thumbnailImageView.leadingAnchor),
            tweetOptionsStackView.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            tweetOptionsStackView.trailingAnchor.constraint(equalTo: thumbnailImageView.trailingAnchor),
            tweetOptionsStackView.heightAnchor.constraint(equalToConstant: 20)
            ])
    }
    
    private func activateSeparatorLineConstraints() {
        NSLayoutConstraint.activate([
            separatorLine.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            separatorLine.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            separatorLine.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            separatorLine.heightAnchor.constraint(equalToConstant: 0.5)
            ])
    }
    
    private func setupStackOptions() {
        commentButton.iconImage = UIImage(named: "comment_ic")
        commentButton.label = "481"
        
        retweetButton.iconImage = UIImage(named: "retweet_ic")
        retweetButton.label = "1.456"
        
        likeButton.iconImage = UIImage(named: "like_ic")
        likeButton.label = "22,3K"
        
        shareButton.iconImage = UIImage(named: "share_ic")
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
