//
//  UIImageView+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

extension UIImageView {
    func design(image: UIImage?=nil,contentMode: UIView.ContentMode = .scaleAspectFill, cornerRadius: CGFloat = 8) {
        self.image = image
        self.contentMode = contentMode
        self.clipsToBounds = true
        self.layer.cornerRadius = cornerRadius
    }
}
