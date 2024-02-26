//
//  SearchResultView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class SearchResultView: BaseView {
    let searchCountLabel = UILabel()
    
    let filterStackView = UIStackView()
    let accuracyButton = FilterButton()
    let dateOrderButton = FilterButton()
    let hPriceOrderButton = FilterButton()
    let lPriceOrderButton = FilterButton()
    
    lazy var filterButtons: [UIButton] = [
        accuracyButton, dateOrderButton,
        hPriceOrderButton, lPriceOrderButton]
    
    
    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    
    func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let cellWidth = UIScreen.main.bounds.width - (spacing*2) - 32
        layout.itemSize = .init(width: cellWidth/2, height: (cellWidth/2) * 1.5)
        layout.minimumLineSpacing = 12
        layout.minimumInteritemSpacing = 12
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .vertical
        
        return layout
    }
    
    override func configureHierarchy() {
        [searchCountLabel, filterStackView, productCollectionView].forEach {
            addSubview($0)
        }
        
        [accuracyButton, dateOrderButton, hPriceOrderButton, lPriceOrderButton].forEach {
            filterStackView.addArrangedSubview($0)
        }
    }
    
    override func configureLayout() {
        searchCountLabel.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(12)
            make.horizontalEdges.equalToSuperview().inset(16)
            make.height.equalTo(18)
        }
        
        filterStackView.snp.makeConstraints { make in
            make.top.equalTo(searchCountLabel.snp.bottom).offset(12)
            make.leading.equalTo(searchCountLabel)
        }
        
        filterButtons.forEach {
            $0.snp.makeConstraints { make in
                make.height.equalTo(28)
            }
        }
        
        productCollectionView.snp.makeConstraints { make in
            make.top.equalTo(filterStackView.snp.bottom).offset(12)
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide)
        }
    }
    
    // 뷰 디자인
    override func configureView() {
        searchCountLabel.design(text: "0 개의 검색 결과", textColor: ColorStyle.pointColor, font: .boldSystemFont(ofSize: 13))
        
        filterStackView.design(distribution: .equalSpacing, spacing: 8)
        
        filterButtons[0].tag = 0
        
        productCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
}
