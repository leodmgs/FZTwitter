//
//  FZUserTimelineViewController.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/24/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class FZUserTimelineViewController: UIViewController {
    
    // MARK: - Outlets
    
    @IBOutlet var timelineCollectionView: UICollectionView!
    
    
    // MARK: - Attributes
    
    private let twitterQueryService: FZTwitterQueryService = {
        return FZTwitterQueryService.shared
    }()
    
    private let tweetDatasource: FZTweetDatasource = {
        let datasource = FZTweetDatasource()
        return datasource
    }()
    
    var user: FZUser? {
        didSet {
            guard let userObject = user else { return }
            tweetDatasource.dropDatasource()
            twitterQueryService.timeline(for: userObject.id, completion: { tweets in
                if let tweetObjects = tweets {
                    self.tweetDatasource.add(dataCollection: tweetObjects)
                }
                DispatchQueue.main.async {
                    self.timelineCollectionView.reloadData()
                }
            })
        }
    }
    

    // MARK: - Functions
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    private func setupNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    private func setupView() {
        timelineCollectionView.delegate = self
        timelineCollectionView.dataSource = self
        timelineCollectionView.register(GenericCell.self, forCellWithReuseIdentifier: GenericCell.identifier)
        
        timelineCollectionView.register(UINib(nibName: "FZUserCollectionReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FZUserCollectionReusableView.id")
        
        timelineCollectionView.register(UINib(nibName: "FZTwitterFilterReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FZTwitterFilterReusableView.id")
        
        timelineCollectionView.register(UINib(nibName: "FZUserInfoCell", bundle: nil), forCellWithReuseIdentifier: "FZUserInfoCell.id")
        
        timelineCollectionView.register(UINib(nibName: "FZTweetCell", bundle: nil), forCellWithReuseIdentifier: "FZTweetCell.id")
    
        if let layout = timelineCollectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            layout.sectionHeadersPinToVisibleBounds = true
        }
    }
    
    func configureUserHeader(_ header: FZUserCollectionReusableView) {
        guard let user = self.user else { return }
        
        if let urlProfile = user.urlProfileImage, let urlBg = user.urlProfileBackgroundImage {
            header.profileImage.fetchImage(urlProfile)
            header.backgroundImage.fetchImage(urlBg)
        }
        header.usernameLabel.attributedText = attributedUsername(user.name, user.verified, user.screenName)
    }
    
    func configureUserDescription(_ cell: FZUserInfoCell) {
        guard let user = self.user else { return }
        cell.descriptionLabel.attributedText = attributedDescription(user.description)
        let strDate = formatDateInfo(strDate: user.createdAt)
        cell.createtAtLabel.attributedText = attributedCreatedAt(strDate)
        cell.followsLabel.attributedText = attributedFollowsInfo(user.friends, user.followers)
    }
    
    private func configureTweetCell(_ cell: FZTweetCell, _ indexPath: IndexPath) {
        let tweet = tweetDatasource.index(at: indexPath.item)
        cell.tweetText.text = tweet?.text
        if let tweetObject = tweet, let tweetOwner = tweetObject.user {
            cell.setUserInfoLabel(
                tweetOwner.name,
                tweetOwner.verified,
                tweetOwner.screenName)
            if let urlProfile = tweetOwner.urlProfileImage {
                cell.profileImageView.fetchImage(urlProfile)
            }
            if tweetObject.mediaUrl != nil {
                cell.mediaImageView.fetchImage(tweetObject.mediaUrl!)
                cell.mediaImageView.isHidden = false
            } else {
                cell.mediaImageView.isHidden = true
            }
        }
        // FIXME: parse tweet time to calculate the time elapsed
        cell.setTimeElapsed("3h")
    }
    
    private func estimatedBoundingTextViewSize(text: String, offset: CGFloat = 0) -> CGSize {
        let textViewFrameWidth = view.frame.width - 82
        let textViewFrameSize = CGSize(width: textViewFrameWidth, height: 1000)
        let fontAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15.0)!]
        let boundingSize = NSString(string: text).boundingRect(with: textViewFrameSize, options: .usesLineFragmentOrigin, attributes: fontAttributes, context: nil)
        return CGSize(width: view.frame.width, height: boundingSize.height + offset)
    }
    
    private func formatDateInfo(strDate: String) -> String {
        var dateFormatted = ""
        let dateFormatterGet = DateFormatter()
        
        // Format user by Twitter
        dateFormatterGet.dateFormat = "E MMM d HH:mm:ss Z yyyy"
        dateFormatterGet.locale = Locale(identifier: "en_US_POSIX")
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM yyyy"
        
        if let date = dateFormatterGet.date(from: strDate) {
            dateFormatted = dateFormatterPrint.string(from: date)
        }
        return dateFormatted
    }
    
    private func attributedFollowsInfo(_ following: Int, _ followers: Int) -> NSMutableAttributedString {
        let descAttr = NSMutableAttributedString()
        
        descAttr.append(NSAttributedString(
            string: "\(following) ",
            attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 14)!]))
        
        descAttr.append(NSAttributedString(
            string: "Following  ",
            attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14)!]))
        
        descAttr.append(NSAttributedString(
            string: "\(followers) ",
            attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 14)!]))
        
        descAttr.append(NSAttributedString(
            string: "Followers",
            attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 14)!]))
        
        return descAttr
    }
    
    private func attributedCreatedAt(_ date: String) -> NSMutableAttributedString {
        let descAttr = NSMutableAttributedString()
        descAttr.append(NSAttributedString(
            string: "Joined \(date)",
            attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)!]))
        return descAttr
    }
    
    private func attributedDescription(_ text: String) -> NSMutableAttributedString {
        let descAttr = NSMutableAttributedString()
        descAttr.append(NSAttributedString(
            string: text,
            attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 15)!]))
        return descAttr
    }
    
    private func attributedUsername(_ name: String, _ isVerified: Bool, _ username: String) -> NSMutableAttributedString {
        let userInfoAttr = NSMutableAttributedString()
        
        userInfoAttr.append(NSAttributedString(string: "\(name) ", attributes: [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Bold", size: 25)!]))
        
        if isVerified {
            let verifiedImage = NSTextAttachment()
            verifiedImage.image = UIImage(named: "verified_profile")
            verifiedImage.bounds = CGRect(x: 0, y: -2, width: 16, height: 16)
            let imageString = NSAttributedString(attachment: verifiedImage)
            userInfoAttr.append(imageString)
        }
        
        userInfoAttr.append(NSAttributedString(string: "@\(username)", attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 25.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.47, blue: 0.52, alpha: 1)]))
        
        return userInfoAttr
    }
    
}

extension FZUserTimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return tweetDatasource.datasource?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let userInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FZUserInfoCell.id", for: indexPath) as! FZUserInfoCell
            configureUserDescription(userInfoCell)
            return userInfoCell
        case 1:
            let tweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FZTweetCell.id", for: indexPath) as! FZTweetCell
            configureTweetCell(tweetCell, indexPath)
            return tweetCell
        default:
            debugPrint("Warning: Unable to find section \(indexPath.section).")
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: GenericCell.identifier, for: indexPath)
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        switch indexPath.section {
        case 0:
            if kind == UICollectionView.elementKindSectionHeader {
                let userHeaderReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FZUserCollectionReusableView.id", for: indexPath) as! FZUserCollectionReusableView
                userHeaderReusableView.delegate = self
                configureUserHeader(userHeaderReusableView)
                return userHeaderReusableView
            }
        case 1:
            if kind == UICollectionView.elementKindSectionHeader {
                let twitterFilterReusableView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FZTwitterFilterReusableView.id", for: indexPath) as! FZTwitterFilterReusableView
                return twitterFilterReusableView
            }
        default:
            debugPrint("Warning: Unable to find section \(indexPath.section).")
        }
        // FIXME: provide a generic header
        return UICollectionReusableView()
    }
    
}

extension FZUserTimelineViewController: FZUserCollectionHeaderDelegate {
    
    func didBackTapped() {
        _ = navigationController?.popViewController(animated: true)
    }
    
}

extension FZUserTimelineViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        
        switch indexPath.section {
        
        case 0: // User info cell
            
            // FIXME: estimate size based on cell attributes
            return CGSize(width: screenWidth, height: 120)
        
        case 1: // Tweet cells
            let tweet = tweetDatasource.index(at: indexPath.item)
            if let tweetText = tweet?.text {
                // FIXME: ???
                // 270 is the offset calculated by the sum of height of username, thumbnail, options and alignment constraints
                var offset: CGFloat = 270
                if tweet?.mediaUrl == nil {
                    offset -= 160
                }
                let textViewFrameHeight = estimatedBoundingTextViewSize(text: tweetText, offset: offset)
                return textViewFrameHeight
            }
            let screenWidth = UIScreen.main.bounds.width
            return CGSize(width: screenWidth, height: 200)
        
        default:
            return CGSize(width: screenWidth, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        if section == 0 {
            return CGSize(width: screenWidth, height: 230)
        }
        return CGSize(width: screenWidth, height: 70)
    }
    
    
    
}

class GenericCell: UICollectionViewCell {
    
    static let identifier = "GenericCell"
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    private func setupView() {
        
    }
    
}
