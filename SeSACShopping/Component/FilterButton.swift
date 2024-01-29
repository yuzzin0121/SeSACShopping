//
//  FilterButton.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/29/24.
//

import UIKit

class FilterButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        titleLabel?.font = .systemFont(ofSize: 14)
        backgroundColor = ColorStyle.backgroundColor
        layer.cornerRadius = 8
        layer.borderColor = ColorStyle.textColor.cgColor
        layer.borderWidth = 1
        contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
