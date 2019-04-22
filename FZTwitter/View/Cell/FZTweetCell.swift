//
//  FZTweetCell.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/22/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit

class FZTweetCell: UICollectionViewCell {
    
    @IBOutlet var profileImage: UIImageView!
    @IBOutlet var username: UILabel!
    @IBOutlet var tweetText: UITextView!
    @IBOutlet var mediaContainer: UIView!
    @IBOutlet var tweetOptionsStackView: UIStackView!
    @IBOutlet var tweetOption: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        
    }

}
