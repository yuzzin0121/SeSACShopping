//
//  ProfileImageSettingView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class ProfileImageSettingView: BaseView {
    let selectedProfileImageView = ProfileImageView(frame: .zero)
    lazy var profileImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    
    func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 36
        let cellWidth = (UIScreen.main.bounds.width - spacing*2) / 4
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    
    override func configureHierarchy() {
        [selectedProfileImageView, profileImageCollectionView].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        selectedProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        profileImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedProfileImageView.snp.bottom).offset(36)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // 뷰 디자인
    override func configureView() {
        profileImageCollectionView.backgroundColor = ColorStyle.backgroundColor
    }
}
