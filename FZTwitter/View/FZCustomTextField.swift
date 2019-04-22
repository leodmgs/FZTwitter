//
//  FZCustomTextField.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/20/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class FZCustomTextField: UITextField {
    
    // MARK: Attributes
    
    // Customize some padding when leftView is visible on text field
    @IBInspectable var leftViewPadding: CGFloat = 0
    
    // Text to placeholder.
    var customPlaceholder: String?
    
    // This image is used with attributed placeholder text.
    var leftPlaceholderIcon: UIImage?
    
    // Make sure text field is properly displayed on bar.
    override var intrinsicContentSize: CGSize {
        return UIView.layoutFittingExpandedSize
    }
    
    // MARK: Functions
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupTextField()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupTextField()
    }
    
    // Add padding to the leftView of this text field
    override func leftViewRect(forBounds bounds: CGRect) -> CGRect {
        var leftViewRect = super.leftViewRect(forBounds: bounds)
        leftViewRect.origin.x += leftViewPadding
        return leftViewRect
    }
    
    private func setupTextField() {
        // FIXME: create an extension to provide custom colors
        backgroundColor = UIColor(red: 0.88, green: 0.91, blue: 0.93, alpha: 1)
        layer.cornerRadius = 16
        clipsToBounds = true
        textAlignment = .center
        
        let searchView = UIImageView(
            frame: CGRect(x: 0, y: -2, width: 26, height: 16))
        searchView.image = UIImage(named: "search_ic")
        searchView.contentMode = .center
        leftView = searchView
        
        customPlaceholder = "Search Twitter"
        leftPlaceholderIcon = UIImage(named: "search_ic")
        activateBasePlaceholder()
    }
    
    // MARK: add comment
    func activateBasePlaceholder() {
        setPlaceholder(text: customPlaceholder!, image: leftPlaceholderIcon!, attributes: nil)
    }
    
    // MARK: add comment
    func activateEditingPlaceholder() {
        setPlaceholder(text: customPlaceholder!, image: nil, attributes: nil)
    }
    
    // MARK: add comment
    func activateResultPlaceholder(for query: String) {
        let queryAttributed = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 17.0)!, NSAttributedString.Key.foregroundColor: UIColor.black]
        setPlaceholder(text: query, image: leftPlaceholderIcon!, attributes: queryAttributed)
    }
    
    private func setPlaceholder(text: String, image: UIImage?, attributes: [NSAttributedString.Key: Any]?) {
        let placeholder = NSMutableAttributedString()
        
        if let iconImage = image {
            let imageAttachment = NSTextAttachment()
            imageAttachment.image = iconImage
            imageAttachment.bounds = CGRect(x: -5, y: -2, width: 16, height: 16)
            let imageString = NSAttributedString(attachment: imageAttachment)
            placeholder.append(imageString)
        }
        
        if let customAttributes = attributes {
            placeholder.append(NSAttributedString(string: text, attributes: customAttributes))
        } else {
            let textAttributes = [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 17.0)!, NSAttributedString.Key.foregroundColor: UIColor(red: 0.40, green: 0.47, blue: 0.52, alpha: 1)]
            placeholder.append(NSAttributedString(string: text, attributes: textAttributes))
        }
        
        attributedPlaceholder = placeholder
    }
    
}
