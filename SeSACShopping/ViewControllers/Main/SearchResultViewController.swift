//
//  SearchResultViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/20/24.
//

import UIKit

/*
1. 네비게이션 타이틀 영역에 검색 키워드를 표현한다.
 - 검색 키워드는 1) 메인 화면 서치바에 입력한 텍스트 or 2) 최근 검색 리스트에서 클릭한 키워드가 전달된다.
2. 검색 데이터는 네이버 쇼핑 API를 활용한다.
 - 데이터는 30개를 기준으로 페이지네이션 처리를 한다.
 - API 쿼리를 활용해 정렬 기능을 구현한다.
 - 상품 전체 갯수를 total를 통해 보여준다.
 3. 셀에서는 image, mallName, title, lprice 정보를 확인할 수 있으며, title은 2줄까지 보여진다.
 4. 사용자가 상품마다 좋아요를 설정하거나 취소할 수 있다.
 5. 셀 선택 시 [상품 상세 화면]으로 이동한다.
 */
// 검색 결과 화면

enum Filter: Int, CaseIterable {
    case accuracy
    case dateOrder
    case hPriceOrder
    case lPriceOrder
    
    var title: String {
        switch self {
        case .accuracy: return "정확도"
        case .dateOrder: return "날짜순"
        case .hPriceOrder: return "가격높은순"
        case .lPriceOrder: return "가격낮은순"
        }
    }
    
    var sortValue: String { // 파라미터 key(sort)에 대한 값
        switch self {
        case .accuracy: return "sim"
        case .dateOrder: return "date"
        case .hPriceOrder: return "dsc"
        case .lPriceOrder: return "asc"
        }
    }
}

class SearchResultViewController: UIViewController, ViewProtocol {
    @IBOutlet weak var searchCountLabel: UILabel!
    
    @IBOutlet weak var accuracyButton: UIButton!
    @IBOutlet weak var dateOrderButton: UIButton!
    @IBOutlet weak var hPriceOrderButton: UIButton!
    @IBOutlet weak var lPriceOrderButton: UIButton!
    
    lazy var filterButtons: [UIButton] = [accuracyButton, dateOrderButton, hPriceOrderButton, lPriceOrderButton]
    @IBOutlet weak var productCollectionView: UICollectionView!
    
    var searchKeyword: String?
    let filterList: [Filter] = Filter.allCases
    let productAPIManager = ProductAPIManager()
    var productList: [Product] = [] {
        didSet {
            productCollectionView.reloadData()
        }
    }
    var searchCount: Int = 0 {
        didSet {
            let count = searchCount.convertPriceString()
            searchCountLabel.text = "\(count) 개의 검색 결과"
        }
    }

    var selectedIndex = 0
    var isEnd = false
    var start = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        designViews()
        configureCollectionView()
        
        productAPIManager.callRequest(keyword: searchKeyword ?? "", sort: filterList[0].sortValue) { productsInfo in
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        
    }
    
    @IBAction func filterButtonClicked(_ sender: UIButton) {
        filterButtons[selectedIndex].backgroundColor = ColorStyle.backgroundColor
        filterButtons[selectedIndex].setTitleColor(ColorStyle.textColor, for: .normal)
        filterButtons[selectedIndex].layer.borderColor = ColorStyle.textColor.cgColor
        filterButtons[selectedIndex].layer.borderWidth = 1
        
        let index = sender.tag
        filterButtons[index].backgroundColor = ColorStyle.textColor
        filterButtons[index].setTitleColor(ColorStyle.backgroundColor, for: .normal)
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
    
    func configureCollectionView() {
        productCollectionView.delegate = self
        productCollectionView.dataSource = self
        productCollectionView.prefetchDataSource = self
        productCollectionView.backgroundColor = ColorStyle.backgroundColor
        let layout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 12
        let cellWidth = UIScreen.main.bounds.width - (spacing*2) - 32
        layout.itemSize = .init(width: cellWidth/2, height: (cellWidth/2) * 1.5)
        layout.sectionInset = UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        layout.scrollDirection = .vertical
        productCollectionView.collectionViewLayout = layout
        
        let productNib = UINib(nibName: ProductCollectionViewCell.identifier, bundle: nil)
        productCollectionView.register(productNib, forCellWithReuseIdentifier: ProductCollectionViewCell.identifier)
    }
    
    // navigationItem 디자인
    func configureView() {
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
    
    // 뷰 디자인
    func designViews() {
        view.backgroundColor = ColorStyle.backgroundColor
        
        searchCountLabel.design(text: "0 개의 검색 결과", textColor: ColorStyle.pointColor, font: .boldSystemFont(ofSize: 13))
        
        for index in 1...filterButtons.count - 1 {
            filterButtons[index].design(title: filterList[index].title,
                                        backgroundColor: ColorStyle.backgroundColor,
                                        cornerRadius: 8,
                                        borderColor: ColorStyle.textColor.cgColor)
            filterButtons[index].contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
            filterButtons[index].tag = index
        }
        
        filterButtons[0].design(title: filterList[0].title, titleColor: ColorStyle.backgroundColor,
                                backgroundColor: ColorStyle.textColor, cornerRadius: 8)
        filterButtons[0].contentEdgeInsets = UIEdgeInsets(top: 0, left: 6, bottom: 0, right: 6)
        filterButtons[0].tag = 0
    }
    
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
        
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let ProductDetailVC = MainSB.instantiateViewController(withIdentifier: ProductDetailViewController.identifier) as! ProductDetailViewController
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