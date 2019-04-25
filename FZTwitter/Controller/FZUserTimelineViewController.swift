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
    
    @IBOutlet var timelineCollectionView: UICollectionView!
    
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
    
}

extension FZUserTimelineViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        }
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch indexPath.section {
        case 0:
            let userInfoCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FZUserInfoCell.id", for: indexPath) as! FZUserInfoCell
            return userInfoCell
        case 1:
            let tweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FZTweetCell.id", for: indexPath) as! FZTweetCell
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
        case 0:
            return CGSize(width: screenWidth, height: 200)
        case 1:
            return CGSize(width: screenWidth, height: 400)
        default:
            return CGSize(width: screenWidth, height: 100)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        if section == 0 {
            return CGSize(width: screenWidth, height: 220)
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
