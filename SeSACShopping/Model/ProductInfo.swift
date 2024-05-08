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
    var items: [ProductItem]
}

struct ProductItem: Decodable {
    let title: String
    let image: String?
    let lprice: String
    let mallName: String
    let productId: String
    var isLike: Bool?
    
    enum CodingKeys: CodingKey {
        case title
        case image
        case lprice
        case mallName
        case productId
        case isLike
    }
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.title = try container.decode(String.self, forKey: .title)
        self.image = try container.decodeIfPresent(String.self, forKey: .image)
        self.lprice = try container.decode(String.self, forKey: .lprice)
        self.mallName = try container.decode(String.self, forKey: .mallName)
        self.productId = try container.decode(String.self, forKey: .productId)
        self.isLike = try container.decodeIfPresent(Bool.self, forKey: .isLike) ?? false
    }
}
