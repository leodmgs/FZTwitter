//
//  FZTweetsCollectionView.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/22/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import UIKit

class FZTweetsCollectionView: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupView()
    }
    
    func setupView() {
        Bundle.main.loadNibNamed("FZTweetsCollectionView", owner: self, options: nil)
        
        collectionView.register(UINib(nibName: "FZTweetCell", bundle: nil), forCellWithReuseIdentifier: "FZTweetCell.id")
        
        collectionView.register(UINib(nibName: "FZTweetHeaderReusableView", bundle: nil), forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "FZTweetHeaderReusableView.id")
        
        contentView.frame = self.frame
        addSubview(contentView)
        contentView.addSubview(collectionView)
        
    }

}
