//
//  ProfileImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit
import SnapKit

class ProfileImageCollectionViewCell: UICollectionViewCell, CellProtocol, ViewProtocol {
    
    let profileImageView = ProfileImageView(frame: .zero)
    var isClicked = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureView()
        setupContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    func configureCell(item: Any) {
        let profile = item as! Profile
        profileImageView.image = profile.profileImage
        isBorder(status: profile.isSelected)
    }
    
    func isBorder(status: Bool) {
        profileImageView.layer.borderWidth = status ? 4 : 0
        profileImageView.layer.borderColor = status ? ColorStyle.pointColor.cgColor : UIColor.clear.cgColor
    }
    
    func configureHierarchy() {
        contentView.addSubview(profileImageView)
    }
    
    func configureView() {
        
    }
    
    func setupContstraints() {
        profileImageView.snp.makeConstraints { make in
            make.edges.equalToSuperview().inset(6)
            make.width.equalTo(profileImageView.snp.height)
        }
    }
}
