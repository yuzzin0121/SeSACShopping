//
//  PointButton.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/29/24.
//

import UIKit

class PointButton: UIButton {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        titleLabel?.font = .boldSystemFont(ofSize: 16)
        setTitleColor(ColorStyle.textColor, for: .normal)
        backgroundColor = ColorStyle.pointColor
        clipsToBounds = true
        layer.cornerRadius = 8
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
