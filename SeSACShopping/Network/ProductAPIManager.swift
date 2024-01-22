//
//  ProductAPI.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import Foundation
import Alamofire

struct ProductAPIManager {
    func callRequest(keyword: String, sort: String, start: Int = 1, completionHandler: @escaping (ProductsInfo) -> Void) {
        // 한글 검색이 안된다면 인코딩 처리
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query ?? keyword)&display=30&sort=\(sort)&start=\(start)"
        
        let headers: HTTPHeaders = [
            "X-Naver-Client-Id": APIKey.clientID,
            "X-Naver-Client-Secret": APIKey.clientSecret
        ]
        
        AF.request(url, 
                   method: .get,
                   headers: headers)
            .responseDecodable(of: ProductsInfo.self) { response in
                switch response.result {
                case .success(let success):
                    completionHandler(success)
                case .failure(let failure):
                    print(failure)
                }
            }
    }
}
