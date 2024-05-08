//
//  NetworkError.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/7/24.
//

import Foundation

enum NetworkError: Error {
    case failedRequest
    case noData
    case invalidResponse
    case invalidData
    case unknown
    
    var message: String {
        switch self {
        case .failedRequest:
            return "요청에 실패하였습니다."
        case .noData:
            return "데이터가 없습니다!"
        case .invalidResponse:
            return "응답이 잘못되었습니다"
        case .invalidData:
            return "데이터가 잘못되었습니다."
        case .unknown:
            return "알 수 없는 오류가 발생했습니다."
        }
    }
}
