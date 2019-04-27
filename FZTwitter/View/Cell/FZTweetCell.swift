//
//  FZTweetCell.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/22/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit


// MARK: - Defines the kind of option this object is or should handle
enum FZTweetOption {
    // Events from buttons
    enum Event {
        case like
        case retweet
    }
    // TODO: - Add new options if necessary
}


// MARK: - Tells the delegate about tweet events
protocol FZTweetCellDelegate {
    func onLikeTweet()
    func onRetweet()
}


class FZTweetCell: UICollectionViewCell {
    
    // MARK: Outlets
        
    @IBOutlet var profileImageView: FZCustomImageView!
    @IBOutlet var userInfo: UILabel!
    @IBOutlet var timeElapsedLabel: UILabel!
    @IBOutlet var tweetText: UITextView!
    @IBOutlet var mediaImageView: FZCustomImageView!
    @IBOutlet var tweetOptionsStackView: UIStackView!
    @IBOutlet var tweetOption: UIButton!
    @IBOutlet var separatorLine: UIView!
    
    @IBOutlet var commentButton: UIButton!
    @IBOutlet var retweetButton: UIButton!
    @IBOutlet var likeButton: UIButton!
    @IBOutlet var shareButton: UIButton!
    
    // MARK: Attributes
    
    var delegate: FZTweetCellDelegate?
    
    var indexPath: IndexPath?
    
    var likesCount: Int = 0
    var retweetsCount: Int = 0
    
    var hasLiked = false
    var hasRetweeted = false
    
    
    // MARK: Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        
        profileImageView.layer.cornerRadius = 24
        profileImageView.clipsToBounds = true
        
        mediaImageView.layer.cornerRadius = 12
        mediaImageView.clipsToBounds = true
        
    }
    
    func setTimeElapsed(_ strTime: String) {
        timeElapsedLabel.attributedText = attributedTimeElapsed(for: strTime)
    }
    
    func setUserInfoLabel(_ name: String, _ isVerified: Bool, _ username: String) {
        userInfo.attributedText = attributedUserInfo(name, isVerified, "@\(username)")
    }
    
    func setTweetOption(for event: FZTweetOption.Event, with number: Int) {
        switch event {
        case .like:
            likesCount = number
            updateLikeOption(number)
        case .retweet:
            retweetsCount = number
            updateRetweetOption(number)
        }
    }
    
    private func updateLikeOption(_ number: Int, _ animation: Bool? = false) {
        var titleAttributed: NSAttributedString?
        let titleText = number > 0 ? formatButtonTitle(for: number) : ""
        if hasLiked {
            titleAttributed = attributedTitleLabel(titleText, .fzRed)
            likeButton.imageView?.tintColor = .fzRed
            likeButton.setImage(UIImage(named: "like_ic_full"), for: .normal)
        } else {
            titleAttributed = attributedTitleLabel(titleText)
            likeButton.imageView?.tintColor = .fzDarkGray
            likeButton.setImage(UIImage(named: "like_ic"), for: .normal)
        }
        likeButton.setAttributedTitle(titleAttributed, for: .normal)
        if let hasAnimation = animation, hasAnimation {
            let animationObject = animationForTweetOption()
            likeButton.layer.add(animationObject, forKey: "opacity")
        }
    }
    
    private func updateRetweetOption(_ number: Int, _ animation: Bool? = false) {
        var titleAttributed: NSAttributedString?
        let titleText = number > 0 ? formatButtonTitle(for: number) : ""
        if hasRetweeted {
            titleAttributed = attributedTitleLabel(titleText, .fzGreen)
            retweetButton.imageView?.tintColor = .fzGreen
        } else {
            titleAttributed = attributedTitleLabel(titleText)
            retweetButton.imageView?.tintColor = .fzDarkGray
        }
        retweetButton.setAttributedTitle(titleAttributed, for: .normal)
        if let hasAnimation = animation, hasAnimation {
            let animationObject = animationForTweetOption()
            retweetButton.layer.add(animationObject, forKey: "opacity")
        }
    }
    
    private func formatButtonTitle(for number: Int) -> String {
        if number < 1000 {
            return "\(number)"
        }
        var numberTruncated = 0
        var indicator = ""
        if number < 10000 { // K
            let nKiloString = "\(number)"
            return "\(nKiloString.prefix(1)).\(nKiloString.suffix(3))"
        } else if number < 100000 { // M
            numberTruncated = number / 100
            indicator = "K"
        } else if number < 1000000 { // B
            numberTruncated = number / 1000
            indicator = "M"
        } else if number < 10000000 { // T
            numberTruncated = number / 10000
        }
        let numberString = "\(numberTruncated)"
        var titleFormatted = String(numberString.prefix(2))
        titleFormatted.append(".")
        let suffixOffset = numberString.count-2
        titleFormatted.append(String(numberString.suffix(suffixOffset)))
        titleFormatted.append(indicator)
        return titleFormatted
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
    
    private func attributedTitleLabel(_ text: String, _ color: UIColor? = .fzDarkGray) -> NSAttributedString {
        let titleAttributed = NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 12.0)!,
                         NSAttributedString.Key.foregroundColor: color ?? .fzDarkGray])
        return titleAttributed
    }
    
    private func animationForTweetOption() -> CABasicAnimation {
        let animation = CABasicAnimation(keyPath: "transform.scale")
        animation.toValue = 0.9
        animation.duration = 0.5
        animation.speed = 10
        animation.autoreverses = true
        return animation
    }
    
    
    // MARK: Actions
    
    
    @IBAction func onComment(_ sender: Any) {
        // TODO
        let animation = animationForTweetOption()
        commentButton.layer.add(animation, forKey: "opacity")
    }
    
    
    @IBAction func onRetweet(_ sender: Any) {
        retweetsCount = hasRetweeted ? retweetsCount - 1 : retweetsCount + 1
        hasRetweeted = !hasRetweeted
        updateRetweetOption(retweetsCount, true)
    }
    
    
    @IBAction func onLike(_ sender: Any) {
        likesCount = hasLiked ? likesCount - 1 : likesCount + 1
        hasLiked = !hasLiked
        updateLikeOption(likesCount, true)
    }
    
    
    @IBAction func onShare(_ sender: Any) {
        // TODO
        let animation = animationForTweetOption()
        shareButton.layer.add(animation, forKey: "opacity")
    }
    
}
