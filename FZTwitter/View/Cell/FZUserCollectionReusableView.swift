//
//  FZUserCollectionReusableView.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/24/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit


protocol FZUserCollectionHeaderDelegate {
    func didBackTapped()
}


class FZUserCollectionReusableView: UICollectionReusableView {
    
    // MARK: - Outlets
    
    @IBOutlet var profileImage: FZCustomImageView!
    
    @IBOutlet var backgroundImage: FZCustomImageView!
    
    @IBOutlet var notificationButton: UIButton!
    
    @IBOutlet var followButton: UIButton!
    var isFollowing = false
    
    @IBOutlet var usernameLabel: UILabel!
    
    @IBOutlet var alertButton: UIButton!
    var isAlert = false
    
    // MARK: - Attributes
    
    var delegate: FZUserCollectionHeaderDelegate?
    
    
    // MARK: - Functions
    
    override func awakeFromNib() {
        super.awakeFromNib()
        setupView()
    }
    
    private func setupView() {
        profileImage.layer.borderColor = UIColor.white.cgColor
        
        notificationButton.layer.borderColor = UIColor.fzBlue.cgColor
        
        followButton.layer.borderColor = UIColor.fzBlue.cgColor
    }
    
    
    // MARK: - Actions
    
    @IBAction func onBackTapped(_ sender: Any) {
        guard let delegate = self.delegate else { return }
        delegate.didBackTapped()
    }
    
    @IBAction func onFollowTapped(_ sender: Any) {
        DispatchQueue.main.async {
            if self.isFollowing {
                self.followButton.setTitle("Follow", for: .normal)
                self.followButton.setTitleColor(.fzBlue, for: .normal)
                self.followButton.backgroundColor = .white
            } else {
                self.followButton.setTitle("Following", for: .normal)
                self.followButton.setTitleColor(.white, for: .normal)
                self.followButton.backgroundColor = .fzBlue
            }
        }
        isFollowing = !isFollowing
    }
    
    @IBAction func onAlert(_ sender: Any) {
        DispatchQueue.main.async {
            if self.isAlert {
                self.alertButton.tintColor = .fzBlue
                self.alertButton.backgroundColor = .white
            } else {
                self.alertButton.tintColor = .white
                self.alertButton.backgroundColor = .fzBlue
            }
        }
        isAlert = !isAlert
    }

}
