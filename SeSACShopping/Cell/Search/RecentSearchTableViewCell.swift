//
//  RecentSearchTableViewCell.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell, CellProtocol, ViewProtocol {
    
    let searchImageView = UIImageView()
    let searchKeywordLabel = UILabel()
    let removeButton = UIButton()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        configureHierarchy()
        configureView()
        setupContstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configureHierarchy() {
        [searchImageView, searchKeywordLabel, removeButton].forEach {
            contentView.addSubview($0)
        }
    }
    
    func configureView() {
        backgroundColor = ColorStyle.backgroundColor
        searchImageView.design(image: ImageStyle.search, tintColor: ColorStyle.textColor, contentMode: .scaleAspectFit)
        searchKeywordLabel.design(font: .systemFont(ofSize: 14))
        removeButton.design(image: ImageStyle.xmark, tintColor: .gray, backgroundColor: .clear)
    }
    
    func setupContstraints() {
        searchImageView.snp.makeConstraints { make in
            make.verticalEdges.equalToSuperview().inset(12)
            make.leading.equalToSuperview().inset(16)
            make.width.equalTo(searchImageView.snp.height)
        }
        
        searchKeywordLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(searchImageView.snp.trailing).offset(16)
        }
        
        removeButton.snp.makeConstraints { make in
            make.size.equalTo(16)
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(16)
        }
    }
    
    func configureCell(item: Any) {
        let keyword = item as! String
        searchKeywordLabel.text = keyword
    }
}
