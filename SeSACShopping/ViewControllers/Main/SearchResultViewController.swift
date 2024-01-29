//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/20/24.
//

import UIKit


// 검색 결과 화면
class SearchResultViewController: UIViewController, ViewProtocol {
    let searchCountLabel = UILabel()
    
    let filterStackView = UIStackView()
    let accuracyButton = FilterButton()
    let dateOrderButton = FilterButton()
    let hPriceOrderButton = FilterButton()
    let lPriceOrderButton = FilterButton()
    
    lazy var filterButtons: [UIButton] = [accuracyButton, dateOrderButton, hPriceOrderButton, lPriceOrderButton]
    
    lazy var productCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    
    var searchKeyword: String?  // 검색 키워드
    let filterList: [Filter] = Filter.allCases  // 필터 리스트
    let productAPIManager = ProductAPIManager()
    var productList: [Product] = [] {   // 상품 리스트
        didSet {
            productCollectionView.reloadData()
        }
    }
    var searchCount: Int = 0 {  // 검색 결과 개수
        didSet {
            let count = searchCount.convertPriceString()
            searchCountLabel.text = "\(count) 개의 검색 결과"
        }
    }

    var selectedIndex = 0   // 필터 버튼 선택된 인덱스
    var isEnd = false
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureLayout()
        configureView()
        configureNavigationItem()
        configureCollectionView()
        
        filterButtons.forEach {
            $0.addTarget(self, action: #selector(filterButtonClicked), for: .touchUpInside)
        }
        
        // 상품 검색
        productAPIManager.callRequest(keyword: searchKeyword ?? "", sort: filterList[0].sortValue) { productsInfo in
            self.searchCount = productsInfo.total
            let likeIds = UserDefaultManager.shared.likeProductIds
            var products: [Product] = []
            for product in productsInfo.items {
                var isLike = false
                if likeIds.contains(product.productId) {
                    isLike = true
                }
                products.append(Product(isLike: isLike, productItem: product))
            }
            self.productList = products
        }
    }
    
    // 필터 버튼 클릭했을 때
    @objc func filterButtonClicked(_ sender: UIButton) {
        setButtonDesign(filterButtons[selectedIndex], isActive: false)
        
        let index = sender.tag
        setButtonDesign(filterButtons[index], isActive: true)
        selectedIndex = index
        start = 1
        guard let searchKeyword else { return }
        
        productAPIManager.callRequest(keyword: searchKeyword, sort: filterList[index].sortValue) { productsInfo in
            self.searchCount = productsInfo.total
            let likeIds = UserDefaultManager.shared.likeProductIds
            var products: [Product] = []
            for product in productsInfo.items {
                var isLike = false
                if likeIds.contains(product.productId) {
                    isLike = true
                }
                products.append(Product(isLike: isLike, productItem: product))
            }
            self.productList = products
            self.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
        }
    }
    
    
    func setButtonDesign(_ button: UIButton, isActive: Bool) {
        if isActive {
            button.backgroundColor = ColorStyle.textColor
            button.setTitleColor(ColorStyle.backgroundColor, for: .normal)
        } else {
            button.backgroundColor = ColorStyle.backgroundColor
            button.setTitleColor(ColorStyle.textColor, for: .normal)
            button.layer.borderColor = ColorStyle.textColor.cgColor
            button.layer.borderWidth = 1
        }
    }
    
    func configureCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.prefetchDataSource = self
        productCollectionView.backgroundColor = ColorStyle.backgroundColor

        productCollectionView.register(ProductCollectionViewCell.self, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
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
    
    // navigationItem 디자인
    func configureNavigationItem() {
        if let searchKeyword {
            navigationItem.title = searchKeyword
        } else {
            navigationItem.title = "검색 결과 화면"
        }
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
    
    // pop - 메인 화면으로
    @objc func popView() {
        searchKeyword = nil
        navigationController?.popViewController(animated: true)
    }
    
    func configureHierarchy() {
        [searchCountLabel, filterStackView, productCollectionView].forEach {
            view.addSubview($0)
        }
        
        filterButtons.forEach {
            filterStackView.addArrangedSubview($0)
        }
    }
    
    func configureLayout() {
        searchCountLabel.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(12)
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
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 뷰 디자인
    func configureView() {
        view.backgroundColor = ColorStyle.backgroundColor
        
        searchCountLabel.design(text: "0 개의 검색 결과", textColor: ColorStyle.pointColor, font: .boldSystemFont(ofSize: 13))
        
        filterStackView.design(distribution: .equalSpacing, spacing: 8)
        
        for index in 1...filterButtons.count - 1 {
            filterButtons[index].setTitle(filterList[index].title, for: .normal)
            filterButtons[index].tag = index
        }
        
        filterButtons[0].design(title: filterList[0].title, titleColor: ColorStyle.backgroundColor,
                                backgroundColor: ColorStyle.textColor, cornerRadius: 8)
        filterButtons[0].tag = 0
    }
    
    // 좋아요 버튼 클릭했을 때
    @objc func likeButtonClicked(sender: UIButton) {
        productList[sender.tag].isLike.toggle()
        let isLike = productList[sender.tag].isLike
        var productIds = UserDefaultManager.shared.likeProductIds
        let productId = productList[sender.tag].productItem.productId
        if isLike == true {
            productIds.append(productId)
            UserDefaultManager.shared.likeProductIds = productIds
            UserDefaultManager.shared.likeCount = productIds.count
        } else {
            if let index = productIds.firstIndex(where: { $0 == productId }) {
                productIds.remove(at: index)
                UserDefaultManager.shared.likeProductIds = productIds
                UserDefaultManager.shared.likeCount = productIds.count
            }
        }
        productCollectionView.reloadItems(at: [IndexPath(item: sender.tag , section: 0)])
    }
}

extension SearchResultViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return productList.count 
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProductCollectionViewCell.identifier, for: indexPath) as! ProductCollectionViewCell
        
        cell.configureCell(item: productList[indexPath.row])
        cell.likeButton.tag = indexPath.row
        cell.likeButton.addTarget(self, action: #selector(likeButtonClicked), for: .touchUpInside)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let title = productList[indexPath.row].productItem.title.htmlEscaped
        
        let ProductDetailVC = ProductDetailViewController()
        ProductDetailVC.productTitle = title
        ProductDetailVC.productId = productList[indexPath.row].productItem.productId
        ProductDetailVC.isLike = productList[indexPath.row].isLike
        
        navigationController?.pushViewController(ProductDetailVC, animated: true)
    }
}

extension SearchResultViewController: UICollectionViewDataSourcePrefetching {
    func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        
        for item in indexPaths {
            if productList.count - 6 == item.row && isEnd == false{
                start += 30
                
                if start + 30 - searchCount < 0 {
                    productAPIManager.callRequest(keyword: searchKeyword!, sort: filterList[selectedIndex].sortValue, start: 30) { productsInfo in
                        self.searchCount = productsInfo.total
                        let likeIds = UserDefaultManager.shared.likeProductIds
                        for product in productsInfo.items {
                            var isLike = false
                            if likeIds.contains(product.productId) {
                                isLike = true
                            }
                            self.productList.append(Product(isLike: isLike, productItem: product))
                        }
                    }
                }
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        print("Cancel Prefetching")
    }
}
