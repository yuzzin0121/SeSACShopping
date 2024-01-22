//
//  ProductDetailViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/20/24.
//

import UIKit
import WebKit

/*
 1. [검색 결과 화면]에서 셀을 선택했을 때 [상품 상세 화면]이 보인다.
 2. 네비게이션 영역에 상품 타이틀과 상품의 좋아요 상태를 보여준다.
 3. 웹뷰를 통해 링크 페이지를 보여준다.
 - 상품 링크 URL은 API Response의 {profuctId}를 활용하여 구성한다.
 - URL Example: https://msearch.shopping.naver.com/product/858952927
 4. 사용자가 좋아요를 설정하거나 취소할 수 있다.
 */

// 상품 상세 화면
class ProductDetailViewController: UIViewController, ViewProtocol {
    @IBOutlet weak var webView: WKWebView!
    
    var productTitle: String?
    var link: String?  = nil
    var productId: String? = nil
    var isLike: Bool? = false {
        didSet {
            heartImage = isLike == true ? ImageStyle.likeFill : ImageStyle.like
            navigationItem.rightBarButtonItem?.image = heartImage
        }
    }
    var heartImage: UIImage = ImageStyle.like
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        designViews()
        showWebView()
        
        
    }

    // navigationItem 디자인
    func configureView() {
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
    
    func showWebView() {
        if let productId {
            if let url = URL(string: "https://msearch.shopping.naver.com/product/\(productId)") {
                let request = URLRequest(url: url)
                webView.load(request)
            }
        }
    }
    
    @objc func like() {
        isLike?.toggle()
        guard let productId else { return }
        var productIds = UserDefaultManager.shared.likeProductIds
        
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
    }
    
    // pop - 메인 화면으로
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func designViews() {
        view.backgroundColor = ColorStyle.backgroundColor
    }
    
    
}
