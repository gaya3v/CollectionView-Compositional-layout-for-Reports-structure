//
//  CustomCollectionViewCell.swift
//  Collection view task
//
//  Created by Gayathri V on 10/05/22.
//

import Foundation
import UIKit

class CustomCollectionViewCell: UICollectionViewCell {
    static let identifier = "customCell"
    
    var label: UILabel = {
        let label = UILabel()
        label.lineBreakMode = .byTruncatingTail
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 15, weight: .medium)
        label.textColor = UIColor(named: "fontColour")
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        contentView.addSubview(label)
        self.layer.borderWidth = 0.6
        self.layer.borderColor = UIColor(named: "fontColour")?.resolvedColor(with: self.traitCollection).cgColor
        
        NotificationCenter.default.addObserver(self, selector: #selector(themeChanged), name: Notification.Name(rawValue: "traitCollectionDidChange"), object: nil)
        
        label.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        label.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        label.widthAnchor.constraint(equalTo: contentView.widthAnchor, multiplier: 0.85).isActive = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        label.text = ""
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setLabelText(text: String) {
        label.text = text
    }
    
    @objc func themeChanged(_:Notification) {
        self.layer.borderColor = UIColor(named: "fontColour")?.resolvedColor(with: self.traitCollection).cgColor
    }
    
    //changing border color on theme change
    
    override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        super.traitCollectionDidChange(previousTraitCollection)
        if self.traitCollection.hasDifferentColorAppearance(comparedTo: previousTraitCollection) {
            NotificationCenter.default.post(name: Notification.Name(rawValue: "traitCollectionDidChange"), object: self)
        }
    }
}

