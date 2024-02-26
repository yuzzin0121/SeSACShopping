//
//  SettingView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class SettingView: BaseView {
    let profileBackgroundView = UIView()
    let profileImageView = ProfileImageView(frame: .zero)
    
    let infoStackView = UIStackView()
    let nicknameLabel = UILabel()
    let likeCountLabel = UILabel()
    
    let settingTableView = UITableView(frame: .zero, style: .insetGrouped)
    
    override func configureHierarchy() {
        [profileBackgroundView, settingTableView].forEach {
            addSubview($0)
        }
        
        [profileImageView, infoStackView].forEach {
            profileBackgroundView.addSubview($0)
        }
        
        [nicknameLabel, likeCountLabel].forEach {
            infoStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        profileBackgroundView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(24)
            make.horizontalEdges.equalToSuperview().inset(20)
            make.height.equalTo(100)
        }
        
        profileImageView.snp.makeConstraints { make in
            make.verticalEdges.equalTo(profileBackgroundView).inset(16)
            make.leading.equalTo(profileBackgroundView).offset(16)
            make.width.equalTo(profileImageView.snp.height)
        }
        
        infoStackView.snp.makeConstraints { make in
            make.centerY.equalTo(profileBackgroundView)
            make.leading.equalTo(profileImageView.snp.trailing).offset(32)
            make.trailing.equalTo(profileBackgroundView).inset(16)
        }
        
        nicknameLabel.snp.makeConstraints { make in
            make.height.equalTo(28)
        }
        
        likeCountLabel.snp.makeConstraints { make in
            make.height.equalTo(20)
        }
        
        settingTableView.snp.makeConstraints { make in
            make.top.equalTo(profileBackgroundView.snp.bottom).offset(16)
            make.horizontalEdges.equalToSuperview()
            make.bottom.equalTo(safeAreaLayoutGuide).inset(24)
        }
        
    }
    
    // 뷰 디자인
    override func configureView() {
        profileBackgroundView.backgroundColor = ColorStyle.deepDarkGray
        profileBackgroundView.layer.cornerRadius = 12
    
        infoStackView.design(axis: .vertical)
        
        let nickname = UserDefaultManager.shared.nickname
        nicknameLabel.design(text: "떠나고싶은 \(nickname)",
                             font: .systemFont(ofSize: 17, weight: .bold))
        
        let likeCount = UserDefaultManager.shared.likeCount
        likeCountLabel.design(text: "\(likeCount)개의 상품을 좋아하고 있어요!", font: .boldSystemFont(ofSize: 15))
        likeCountLabel.changeTextColor(keyword: "\(likeCount)개의 상품")
    
        settingTableView.isScrollEnabled = false
        settingTableView.rowHeight = UITableView.automaticDimension
        settingTableView.estimatedRowHeight = 44
    }
}
