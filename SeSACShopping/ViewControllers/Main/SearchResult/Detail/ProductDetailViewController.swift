//
//  ProductDetailViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/20/24.
//

import UIKit

/*
 1. [검색 결과 화면]에서 셀을 선택했을 때 [상품 상세 화면]이 보인다.
 2. 네비게이션 영역에 상품 타이틀과 상품의 좋아요 상태를 보여준다.
 3. 웹뷰를 통해 링크 페이지를 보여준다.
 - 상품 링크 URL은 API Response의 {profuctId}를 활용하여 구성한다.
 - URL Example: https://msearch.shopping.naver.com/product/858952927
 4. 사용자가 좋아요를 설정하거나 취소할 수 있다.
 */

// 상품 상세 화면
class ProductDetailViewController: BaseViewController {
    let mainView = ProductDetailView()
    var productTitle: String?   // 상품 타이틀
    var productId: String? = nil    // 상품 id
    var heartImage: UIImage = ImageStyle.like
    var isLike: Bool? = false { // 좋아요인지
        didSet {
            heartImage = isLike == true ? ImageStyle.likeFill : ImageStyle.like
            navigationItem.rightBarButtonItem?.image = heartImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        showWebView()
    }
    
    override func loadView() {
        view = mainView
    }
    
    // 웹뷰 띄우기
    func showWebView() {
        if let productId {
            if let url = URL(string: "https://msearch.shopping.naver.com/product/\(productId)") {
                let request = URLRequest(url: url)
                mainView.webView.load(request)
            }
        }
    }
    
    // 좋아요 버튼 클릭했을 때
    @objc func like() {
        isLike?.toggle()    // 좋아요 상태 변경
        guard let productId else { return }
        var productIds = UserDefaultManager.shared.likeProductIds   // 저장된 id들 가져오기
        
        if isLike == true { // 좋아요일 경우
            productIds.append(productId)    // productID 추가
            setLike(ids: productIds, count: productIds.count)
        } else {    // 좋아요 아닌경우!
            if let index = productIds.firstIndex(where: { $0 == productId }) {
                productIds.remove(at: index)    // UserDefault에 존재하는 id이면 삭제
                setLike(ids: productIds, count: productIds.count)
            }
        }
    }
    
    func setLike(ids: [String], count: Int) {   // id들과 좋아요 개수 저장
        UserDefaultManager.shared.likeProductIds = ids
        UserDefaultManager.shared.likeCount = count
    }
    
    // pop - 메인 화면으로
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    // navigationItem 디자인
    override func configureNavigationItem() {
        if let productTitle {
            navigationItem.title = "\(productTitle)"
        } else {
            navigationItem.title = "상품 상세 화면"
        }
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        
        let heartItem = UIBarButtonItem(image: heartImage, style: .plain, target: self, action: #selector(like))
        navigationItem.leftBarButtonItem = backItem
        navigationItem.rightBarButtonItem = heartItem
    }
    
}
