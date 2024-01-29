//
//  RecentKeywordHeaderView.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/29/24.
//

import UIKit

class RecentKeywordHeaderView: UITableViewHeaderFooterView, ViewProtocol {
    
    let recentSearchLabel = UILabel()
    let removeAllButton = UIButton()

    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureView()
        configureLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        [recentSearchLabel, removeAllButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureView() {
        contentView.backgroundColor = ColorStyle.backgroundColor 
        recentSearchLabel.design(text: "최근 검색", font: .boldSystemFont(ofSize: 14))
        removeAllButton.design(title: "모두 지우기", font: .boldSystemFont(ofSize: 14), titleColor: ColorStyle.pointColor, backgroundColor: .clear)
    }
    
    func configureLayout() {
        recentSearchLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(16)
            make.centerY.equalToSuperview()
        }
        
        removeAllButton.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(16)
            make.centerY.equalToSuperview()
            make.height.equalTo(20)
        }
    }
}
