//
//  ProductDetailView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit
import WebKit

class ProductDetailView: BaseView {
    let webView = WKWebView()
    
    override func configureHierarchy() {
        addSubview(webView)
    }
    
    override func configureLayout() {
        webView.snp.makeConstraints { make in
            make.edges.equalTo(safeAreaLayoutGuide)
        }
    }
}
