//
//  Filter.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import Foundation

// 검색 필터
enum Filter: Int, CaseIterable {
    case accuracy
    case dateOrder
    case hPriceOrder
    case lPriceOrder
    
    var title: String { // 버튼에 보여질 title
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
