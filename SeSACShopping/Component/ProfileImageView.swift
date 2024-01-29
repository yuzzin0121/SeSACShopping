//
//  ProfileImageView.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/29/24.
//

import UIKit

class ProfileImageView: UIImageView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureView()
    }
    
    func configureView() {
        isUserInteractionEnabled = true
        clipsToBounds = true
        layer.cornerRadius = self.frame.height / 2
        layer.borderWidth = 4
        layer.borderColor = ColorStyle.pointColor.cgColor
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
