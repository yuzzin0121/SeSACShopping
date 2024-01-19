//
//  UINavigationController+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

extension UINavigationController {

    func setupBarAppearance() {
        let appearance = UINavigationBarAppearance()
        appearance.configureWithDefaultBackground()
        appearance.backgroundColor = ColorStyle.backgroundColor
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: ColorStyle.textColor]
        
        navigationBar.standardAppearance = appearance
        navigationBar.compactAppearance = appearance
        navigationBar.scrollEdgeAppearance = appearance
        navigationBar.tintColor = .white
    }
}
