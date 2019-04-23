//
//  FZTweetOptionButton.swift
//  FZTwitter
//
//  Created by Leonardo Domingues on 4/22/19.
//  Copyright © 2019 Leonardo Domingues. All rights reserved.
//

import Foundation
import UIKit

class FZTweetOptionButton: UIButton {
    
    var iconImage: UIImage? {
        didSet {
            guard let icon = iconImage else { return }
            iconView.image = icon
        }
    }
    
    private let iconView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    var label: String? {
        didSet {
            guard let stringLabel = label else { return }
            textLabel.attributedText = attributedLabelOption(stringLabel)
        }
    }
    
    private let textLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    private func setupButton() {
        textLabel.attributedText = attributedLabelOption("")
        addSubview(iconView)
        addSubview(textLabel)
        activateConstraints()
    }
    
    private func activateConstraints() {
        NSLayoutConstraint.activate([
            iconView.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            iconView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            iconView.widthAnchor.constraint(equalToConstant: 18),
            iconView.heightAnchor.constraint(equalToConstant: 18),
            
            textLabel.centerYAnchor.constraint(equalTo: self.centerYAnchor),
            textLabel.leadingAnchor.constraint(equalTo: iconView.trailingAnchor, constant: 2),
            textLabel.widthAnchor.constraint(equalToConstant: 32),
            textLabel.heightAnchor.constraint(equalToConstant: 18)
            ])
    }
    
    private func attributedLabelOption(_ text: String) -> NSMutableAttributedString {
        let attributedText = NSMutableAttributedString()
        let labelAttributes = NSAttributedString(string: text, attributes: [NSAttributedString.Key.font: UIFont(name: "Helvetica Neue", size: 12.0)!, NSAttributedString.Key.foregroundColor: UIColor.gray])
        attributedText.append(labelAttributes)
        return attributedText
    }
}
