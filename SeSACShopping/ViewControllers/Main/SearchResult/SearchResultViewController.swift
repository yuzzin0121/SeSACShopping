//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/20/24.
//

import UIKit


// 검색 결과 화면
class SearchResultViewController: BaseViewController {
    let mainView = SearchResultView()
    lazy var filterButtons: [UIButton] = [
        mainView.accuracyButton, mainView.dateOrderButton,
        mainView.hPriceOrderButton, mainView.lPriceOrderButton]
    
    var searchKeyword: String?  // 검색 키워드
    let filterList: [Filter] = Filter.allCases  // 필터 리스트
    let productAPIManager = ProductAPIManager()
    var productList: [Product] = [] {   // 상품 리스트
        didSet {
            mainView.productCollectionView.reloadData()
        }
    }
    var searchCount: Int = 0 {  // 검색 결과 개수
        didSet {
            let count = searchCount.convertPriceString()
            mainView.searchCountLabel.text = "\(count) 개의 검색 결과"
        }
    }

    var selectedIndex = 0   // 필터 버튼 선택된 인덱스
    var isEnd = false
    var start = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        configureCollectionView()
        setAction()
        searchProduct(sortValue: filterList.first?.sortValue)
//        if let searchKeyword, let sortValue = filterList.first?.sortValue {
//            print(searchKeyword, sortValue)
//            // 상품 검색
//            ProductSessionManager.shared.fetchNaverProduct(keyword: searchKeyword, sort: sortValue) { productsInfo, networkError in
//                if networkError == nil {
//                    guard let productsInfo = productsInfo else { return }
//                    self.searchCount = productsInfo.total
//                    let likeIds = UserDefaultManager.shared.likeProductIds
//                    var products: [Product] = []
//                    for product in productsInfo.items {
//                        var isLike = false
//                        if likeIds.contains(product.productId) {
//                            isLike = true
//                        }
//                        products.append(Product(isLike: isLike, productItem: product))
//                    }
//                    self.productList = products
//                } else {
//                    guard let error = networkError else { return }
//                    self.printError(error: error)
//                }
//            }
//        }
        
//        productAPIManager.callRequest(keyword: searchKeyword ?? "", sort: filterList[0].sortValue) { productsInfo in
//            self.searchCount = productsInfo.total
//            let likeIds = UserDefaultManager.shared.likeProductIds
//            var products: [Product] = []
//            for product in productsInfo.items {
//                var isLike = false
//                if likeIds.contains(product.productId) {
//                    isLike = true
//                }
//                products.append(Product(isLike: isLike, productItem: product))
//            }
//            self.productList = products
//        }
    }
    
    private func searchProduct(sortValue: String?, start: Int = 1) {
        guard let searchKeyword, let sortValue else {
            print("검색에 필요한 정보가 없습니다.")
            return
        }
        
        Task {
            let searchedProduct = try await ProductSessionManager.shared.fetchNaverProductAsyncAwait(keyword: searchKeyword, sort: sortValue, start: start)
            searchCount = searchedProduct.items.count
            let myLikeList = UserDefaultManager.shared.likeProductIds
            
            var products: [Product] = []
            for product in searchedProduct.items {
                var isLike = false
                if myLikeList.contains(product.productId) {
                    isLike = true
                }
                products.append(Product(isLike: isLike, productItem: product))
            }
            self.productList = products
        }
    }
    
    private func setAction() {
        filterButtons.forEach {
            $0.addTarget(self, action: #selector(filterButtonClicked), for: .touchUpInside)
        }
    }
    
    override func loadView() {
        view = mainView
    }
    
    // 필터 버튼 클릭했을 때
    @objc func filterButtonClicked(_ sender: UIButton) {
        setButtonDesign(filterButtons[selectedIndex], isActive: false)
        
        let index = sender.tag
        setButtonDesign(filterButtons[index], isActive: true)
        selectedIndex = index
        start = 1
        guard let searchKeyword else { return }
        searchProduct(sortValue: filterList[index].sortValue)
        
//        ProductSessionManager.shared.fetchNaverProduct(keyword: searchKeyword, sort: filterList[index].sortValue) { productsInfo, networkError in
//            if networkError == nil {
//                guard let productsInfo = productsInfo else { return }
//                self.searchCount = productsInfo.total
//                let likeIds = UserDefaultManager.shared.likeProductIds
//                var products: [Product] = []
//                for product in productsInfo.items {
//                    var isLike = false
//                    if likeIds.contains(product.productId) {
//                        isLike = true
//                    }
//                    products.append(Product(isLike: isLike, productItem: product))
//                }
//                self.productList = products
//                if !self.productList.isEmpty {
//                    self.mainView.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//                }
//            } else {
//                guard let error = networkError else { return }
//                self.printError(error: error)
//            }
//        }
        
//        productAPIManager.callRequest(keyword: searchKeyword, sort: filterList[index].sortValue) { productsInfo in
//            self.searchCount = productsInfo.total
//            let likeIds = UserDefaultManager.shared.likeProductIds
//            var products: [Product] = []
//            for product in productsInfo.items {
//                var isLike = false
//                if likeIds.contains(product.productId) {
//                    isLike = true
//                }
//                products.append(Product(isLike: isLike, productItem: product))
//            }
//            self.productList = products
//            self.productCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .top, animated: true)
//        }
    }
    
    func configureView() {
        for index in 1...filterButtons.count - 1 {
            filterButtons[index].setTitle(filterList[index].title, for: .normal)
            filterButtons[index].tag = index
        }
        
        filterButtons[0].design(title: filterList[0].title, titleColor: ColorStyle.backgroundColor,
                                backgroundColor: ColorStyle.textColor, cornerRadius: 8)
    }
     
    func printError(error: Error) {
        switch error {
        case NetworkError.failedRequest:
            print(NetworkError.failedRequest.message)
        case NetworkError.invalidData:
            print(NetworkError.invalidData.message)
        case NetworkError.invalidResponse:
            print(NetworkError.invalidResponse.message)
        case NetworkError.noData:
            print(NetworkError.noData.message)
        default:
            print("알 수 없는 오류가 발생했습니다다")
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
        mainView.productCollectionView.delegate = self
        mainView.productCollectionView.dataSource = self
        mainView.productCollectionView.prefetchDataSource = self
        mainView.productCollectionView.backgroundColor = ColorStyle.backgroundColor
    }
    
    
    // navigationItem 디자인
    override func configureNavigationItem() {
        if let searchKeyword {
            navigationItem.title = searchKeyword
        } else {
            navigationItem.title = "검색 결과 화면"
        }
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        backItem.tintColor = ColorStyle.textColor
        navigationItem.leftBarButtonItem = backItem
    }
    
    // pop - 메인 화면으로
    @objc func popView() {
        searchKeyword = nil
        navigationController?.popViewController(animated: true)
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
        mainView.productCollectionView.reloadItems(at: [IndexPath(item: sender.tag , section: 0)])
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
        guard let searchKeyword else { return }
        for item in indexPaths {
            if productList.count - 6 == item.row && isEnd == false{
                start += 30
                
                if start + 30 - searchCount < 0 {
//                    productAPIManager.callRequest(keyword: searchKeyword, sort: filterList[selectedIndex].sortValue, start: 30) { productsInfo in
//                        self.searchCount = productsInfo.total
//                        let likeIds = UserDefaultManager.shared.likeProductIds
//                        for product in productsInfo.items {
//                            var isLike = false
//                            if likeIds.contains(product.productId) {
//                                isLike = true
//                            }
//                            self.productList.append(Product(isLike: isLike, productItem: product))
//                        }
//                    }
                    
                    ProductSessionManager.shared.fetchNaverProduct(keyword: searchKeyword, sort: filterList[selectedIndex].sortValue, start: start) { productsInfo, networkError in
                        if networkError == nil {
                            guard let productsInfo = productsInfo else { return }
                            self.searchCount = productsInfo.total
                            let likeIds = UserDefaultManager.shared.likeProductIds
                            for product in productsInfo.items {
                                var isLike = false
                                if likeIds.contains(product.productId) {
                                    isLike = true
                                }
                                self.productList.append(Product(isLike: isLike, productItem: product))
                            }
                        } else {
                            guard let error = networkError else { return }
                            self.printError(error: error)
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
