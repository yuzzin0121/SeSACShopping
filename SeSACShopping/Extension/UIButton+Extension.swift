//
//  UIButton+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

extension UIButton {
    func design(title: String="", image: UIImage?=nil, titleColor: UIColor = ColorStyle.textColor, backgroundColor: UIColor = ColorStyle.pointColor, cornerRadius: CGFloat = 0) {
        self.backgroundColor = .systemGray5
        self.setTitle(title, for: .normal)
        self.setImage(image, for: .normal)
        self.setTitleColor(titleColor, for: .normal)
        self.backgroundColor = backgroundColor
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
}
