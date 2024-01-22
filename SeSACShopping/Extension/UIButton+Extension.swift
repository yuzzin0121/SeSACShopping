//
//  UIButton+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

extension UIButton {
    func design(title: String="", font: UIFont?=nil, image: UIImage?=nil, tintColor: UIColor = ColorStyle.textColor, titleColor: UIColor = ColorStyle.textColor, backgroundColor: UIColor = ColorStyle.pointColor, cornerRadius: CGFloat = 0, borderColor: CGColor?=nil) {
        self.tintColor = tintColor
        self.backgroundColor = .systemGray5
        self.setTitle(title, for: .normal)
        if let font {
            self.titleLabel?.font = font
        }
        self.setImage(image, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
        
        if let borderColor {
            self.layer.borderColor = borderColor
            self.layer.borderWidth = 1
        }
    }
}
