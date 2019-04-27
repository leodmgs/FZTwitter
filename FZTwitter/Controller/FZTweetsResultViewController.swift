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
            // Prepare the datasource for new objects
            tweetDatasource.dropDatasource()
            resultTextField.activateResultPlaceholder(for: query)
            twitterQueryService.search(query: query, completion: { tweets in
                if let tweetObjects = tweets {
                    self.tweetDatasource.add(dataCollection: tweetObjects)
                }
                self.isLoading = !self.isLoading
                DispatchQueue.main.async {
                    self.tweetsView.collectionView.reloadData()
                }
            })
        }
    }
    
    private let twitterQueryService: FZTwitterQueryService = {
        return FZTwitterQueryService.shared
    }()
    
    private let tweetDatasource: FZTweetDatasource = {
        let datasource = FZTweetDatasource()
        return datasource
    }()
    
    var isLoading: Bool = true
    
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let isHidden = self.navigationController?.isNavigationBarHidden, isHidden {
            self.navigationController?.setNavigationBarHidden(!isHidden, animated: true)
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        if let isHidden = self.navigationController?.isNavigationBarHidden, isHidden {
            self.navigationController?.setNavigationBarHidden(isHidden, animated: true)
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tweetsView.collectionView.collectionViewLayout.invalidateLayout()
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
        let filterItem = UIBarButtonItem(image: UIImage(named: "filter_ic"), style: .plain, target: self, action: nil)
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
            cell.setTweetOption(for: .like, with: tweetObject.favoriteCount)
            cell.setTweetOption(for: .retweet, with: tweetObject.retweetCount)
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
        configureTweetCell(tweetCell, indexPath)
        return tweetCell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionHeader {
            let headerActivityCell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "FZTweetHeaderReusableView.id", for: indexPath)
            return headerActivityCell
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let userTimelineController = FZUserTimelineViewController()
        let tweetSelected = tweetDatasource.index(at: indexPath.item)
        userTimelineController.user = tweetSelected?.user
        navigationController?.pushViewController(userTimelineController, animated: true)
    }
    
    func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
}

extension FZTweetsResultViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
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
        return CGSize(width: screenWidth, height: 400)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return isLoading ? CGSize(width: screenWidth, height: 40) : .zero
    }
    
}
