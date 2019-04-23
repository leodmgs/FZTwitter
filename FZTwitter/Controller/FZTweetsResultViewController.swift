//
//  FZTweetsResultViewController.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/20/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class FZTweetsResultViewController: UIViewController {
    
    // MARK: Attributes

    // FIXME: Unable to add this view through the IB.
    let tweetsView: FZTweetsCollectionView = {
        let view = FZTweetsCollectionView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let resultTextField: FZCustomTextField = {
        let textField = FZCustomTextField()
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    var queryText: String? {
        didSet {
            guard let query = queryText else { return }
            resultTextField.activateResultPlaceholder(for: query)
        }
    }
    
    private let tweetDatasource: FZTweetDatasource = {
        return FZTweetDatasource.shared
    }()
    
    var isLoading: Bool = true
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    @objc private func onSearch() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        tweetsView.collectionView.delegate = self
        tweetsView.collectionView.dataSource = self
        self.view.addSubview(tweetsView)
        
        resultTextField.delegate = self
        resultTextField.addTarget(self, action: #selector(onSearch), for: .touchDown)
        
        activateRegularConstraints()
    }
    
    private func setupNavigationBar() {
        // Add customized text field to the nav bar
        navigationItem.titleView = resultTextField
        
        // FIXME: provide customized colors from an extension
        let twitterBlueColor = UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1)
        
        // Setup the right button item on the navigation bar
        let filterItem = UIBarButtonItem(image: UIImage(named: "filter_ic"), style: .plain, target: self, action: #selector(onFilter))
        filterItem.tintColor = twitterBlueColor
        navigationItem.rightBarButtonItem = filterItem
        
        // Setup the left button item (back) on the navigation bar
        let backItem = UIBarButtonItem(image: UIImage(named: "back_ic"), style: .plain, target: self, action: #selector(onBack))
        backItem.tintColor = twitterBlueColor
        navigationItem.leftBarButtonItem = backItem
    }
    
    @objc private func onBack() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    @objc private func onFilter() {
        isLoading = !isLoading
        DispatchQueue.main.async {
            self.tweetsView.collectionView.reloadData()
        }
    }
    
    
    // MARK: add comments
    private func activateRegularConstraints() {
        NSLayoutConstraint.activate([
            tweetsView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tweetsView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tweetsView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tweetsView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
        ])
        // FIXME: implement a custom bar to handle the constraints according to the context
        NSLayoutConstraint.activate([
            resultTextField.widthAnchor.constraint(equalToConstant: 250),
            resultTextField.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
}


extension FZTweetsResultViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return false
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return false
    }
}


extension FZTweetsResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return tweetDatasource.datasource?.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let tweetCell = collectionView.dequeueReusableCell(withReuseIdentifier: "FZTweetCell.id", for: indexPath) as! FZTweetCell
        tweetCell.setUserInfoLabel("Steve Jobs", true, "@SteveJobs")
        tweetCell.setTimeElapsed("3h")
        return tweetCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerActivityCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FZTweetHeaderReusableView.id", for: indexPath)
            return headerActivityCell
        }
        return UICollectionReusableView()
    }
    
}

extension FZTweetsResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 375, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return isLoading ? CGSize(width: screenWidth, height: 40) : .zero
    }
    
}
