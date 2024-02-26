//
//  MainView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class MainView: BaseView {
    let noSearchWordBackgroundView = UIView()
    let noSearchWordImageView = UIImageView()
    let noSearchWordLabel = UILabel()
    let searchKeywordTableView = UITableView(frame: .zero, style: .grouped)
    
    override func configureHierarchy() {
        [noSearchWordBackgroundView, searchKeywordTableView].forEach {
            addSubview($0)
        }
        
        [noSearchWordImageView, noSearchWordLabel].forEach {
            noSearchWordBackgroundView.addSubview($0)
        }
    }
    
    override func configureView() {
        noSearchWordBackgroundView.backgroundColor = ColorStyle.backgroundColor
        noSearchWordImageView.design(image: ImageStyle.empty, contentMode: .scaleAspectFit)
        noSearchWordLabel.design(text: "최근 검색어가 없어요", font: .boldSystemFont(ofSize: 17), textAlignment: .center)
        
        searchKeywordTableView.rowHeight = 52
        searchKeywordTableView.sectionHeaderTopPadding = 0
        searchKeywordTableView.register(RecentKeywordHeaderView.self, forHeaderFooterViewReuseIdentifier: RecentKeywordHeaderView.identifier)
        searchKeywordTableView.register(RecentSearchTableViewCell.self, forCellReuseIdentifier: RecentSearchTableViewCell.identifier)
    }
    
    override func configureLayout() {
        noSearchWordBackgroundView.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        noSearchWordImageView.snp.makeConstraints { make in
            make.top.horizontalEdges.equalTo(noSearchWordBackgroundView).inset(8)
            make.height.equalTo(268)
        }
        
        noSearchWordLabel.snp.makeConstraints { make in
            make.top.equalTo(noSearchWordImageView.snp.bottom).offset(8)
            make.horizontalEdges.bottom.equalTo(noSearchWordBackgroundView).inset(8)
        }
        
        searchKeywordTableView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
}
