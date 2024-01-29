//
//  UIStackView+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/29/24.
//

import UIKit

extension UIStackView {
    func design(axis: NSLayoutConstraint.Axis = .horizontal, alignment: UIStackView.Alignment = .fill, distribution: UIStackView.Distribution = .fill, spacing: CGFloat = 4) {
        self.axis = axis
        self.alignment = alignment
        self.distribution = distribution
        self.spacing = spacing
    }
}

