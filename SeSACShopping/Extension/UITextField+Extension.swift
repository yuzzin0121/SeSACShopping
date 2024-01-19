//
//  UITextField+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

extension UITextField {
    func design(placeholder: String, backgroundColor: UIColor = ColorStyle.backgroundColor, cornerRadius: CGFloat=0) {
        self.backgroundColor = backgroundColor
        self.placeholder = placeholder
        self.font = .systemFont(ofSize: 15)
        self.textColor = ColorStyle.textColor
        self.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor : UIColor.gray])
        self.layer.borderColor = UIColor.clear.cgColor
        self.layer.borderWidth = 0
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
}
