//
//  FZSearchViewController.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/18/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class FZSearchViewController: UIViewController {
    
    // MARK: Attributes
    
    @IBOutlet weak var searchTextField: FZCustomTextField!
    
    private var rightButtonItem: UIBarButtonItem!
    
    private var profileButtonItem: UIBarButtonItem!
    
    // Indicates if the screen is in search mode.
    private var isSearching: Bool = false
    
    // Image used in runtime.
    private let settingsImage: UIImage = {
        let image = UIImage(named: "settings_ic")!
        return image
    }()
    
    private let profileImage: UIImageView = {
        let imageView = UIImageView(
            frame: CGRect(x: 0, y: 0, width: 32, height: 32))
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        imageView.image = UIImage(named: "profile_img")
        imageView.layer.cornerRadius = 16
        imageView.clipsToBounds = true
        return imageView
    }()
    
    private var rightButton: UIButton = {
        let button = UIButton()
        button.translatesAutoresizingMaskIntoConstraints = false
        // FIXME: define an extension to provide custom colors
        button.setTitleColor(UIColor(red: 0.11, green: 0.63, blue: 0.95, alpha: 1), for: .normal)
        return button
    }()
    
    // MARK: Functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DispatchQueue.main.async {
            // FIXME: add an extension to provide custom colors
            self.view.backgroundColor = UIColor(red: 0.88, green: 0.91, blue: 0.93, alpha: 1)
        }
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if isSearching {
            DispatchQueue.main.async {
                self.searchTextField.becomeFirstResponder()
                self.searchTextField.selectAll(nil)
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let isHidden = self.navigationController?.isNavigationBarHidden, isHidden {
            self.navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
    }
    
//    override func viewWillDisappear(_ animated: Bool) {
//        self.navigationController?.setNavigationBarHidden(true, animated: false)
//    }
    
    private func setupView() {
        profileButtonItem = UIBarButtonItem(customView: profileImage)
        
        rightButton.setImage(settingsImage, for: .normal)
        rightButtonItem = UIBarButtonItem(customView: rightButton)
        rightButton.addTarget(self, action: #selector(onRightItemTapped), for: .touchUpInside)
        
        searchTextField.heightAnchor.constraint(equalToConstant: 32).isActive = true
        
        setupNavigationBar()
    }
    
    private func setupNavigationBar() {
        navigationItem.setLeftBarButtonItems([profileButtonItem, UIBarButtonItem()], animated: false)
        
        navigationItem.setRightBarButtonItems([rightButtonItem, UIBarButtonItem()], animated: false)
        
        NSLayoutConstraint.activate([
            profileImage.widthAnchor.constraint(equalToConstant: 32),
            profileImage.heightAnchor.constraint(equalToConstant: 32)
        ])
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // MARK: to set any property on the destination controller
    }
    
    @IBAction func onSearch(_ sender: Any) {
        if !isSearching {
            isSearching = true
            activateEditingSearchBar()
        }
    }
    
    @objc func onRightItemTapped(_ sender: Any) {
        if isSearching {
            isSearching = false
            searchTextField.text = ""
            restoreBaseSearchBar()
        }
    }
    
    // MARK: add comments
    private func restoreBaseSearchBar() {
        navigationItem.setLeftBarButtonItems([profileButtonItem, UIBarButtonItem()], animated: true)
        
        searchTextField.activateBasePlaceholder()
        searchTextField.textAlignment = .center
        searchTextField.leftViewMode = .never
        searchTextField.endEditing(true)
        
        if let rightItem = rightButtonItem {
            rightButton.setTitle("", for: .normal)
            rightButton.setImage(settingsImage, for: .normal)
            rightItem.customView = rightButton
        }
        
        performAnimationForNavBar()
    }
    
    // MARK: add comments
    private func activateEditingSearchBar() {
        navigationItem.setLeftBarButtonItems([UIBarButtonItem()], animated: true)
        
        searchTextField.activateEditingPlaceholder()
        searchTextField.textAlignment = .left
        searchTextField.leftViewMode = .always
        
        if let rightItem = rightButtonItem {
            rightButton.setImage(nil, for: .normal)
            rightButton.setTitle("Cancel", for: .normal)
            rightButton.titleLabel?.font = UIFont(name: "Helvetica Neue", size: 17.0)
            rightItem.customView = rightButton
        }
        
        performAnimationForNavBar()
    }
    
    private func performAnimationForNavBar() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.5, animations: {
                self.searchTextField.alpha = 0.3
                self.searchTextField.alpha = 1
                self.rightButtonItem.customView?.alpha = 0.5
                self.rightButtonItem.customView?.alpha = 1
            })
        }
    }
    
    // MARK: add comments
    private func performSearch(for query: String) {
        guard let navController = navigationController else { return }
        let searchResultsViewController = FZTweetsResultViewController()
        searchResultsViewController.queryText = query
        navController.pushViewController(searchResultsViewController, animated: true)
    }
    
}


extension FZSearchViewController: UITextFieldDelegate {

    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        return isSearching
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return isSearching
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if let searchText = textField.text, searchText.count > 0 {
            textField.resignFirstResponder()
            performSearch(for: searchText)
        }
        return true
    }
    
    func textFieldShouldEndEditing(_ textField: UITextField) -> Bool {
        return true
    }
}
