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
    
    // MARK: attributes
    
    let tweetsCollectionView: FZTweetsCollectionView = {
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
    
    // MARK: functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationBar()
        setupView()
    }
    
    @objc private func onSearch() {
        _ = navigationController?.popViewController(animated: true)
    }
    
    private func setupView() {
        view.addSubview(tweetsCollectionView)
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
            tweetsCollectionView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tweetsCollectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tweetsCollectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor),
            tweetsCollectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor)
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
