//
//  Product.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import Foundation

// 상품 검색 API decode 모델
struct ProductsInfo: Decodable {
    let total: Int
    let items: [ProductItem]
}

struct ProductItem: Decodable {
    let title: String
    let image: String?
    let lprice: String
    let mallName: String
    let productId: String
}
