//
//  ProductSessionManager.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/7/24.
//

import Foundation

class ProductSessionManager {
    static let shared = ProductSessionManager()
    
    var session: URLSession!
    typealias CompletionHandler = (ProductsInfo?, NetworkError?) -> Void
    
    private init() { }
    
    func fetchNaverProduct(keyword: String, sort: String, start: Int = 1, completionHandler: @escaping CompletionHandler) {
        // 인코딩 처리
        let query = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)
//        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(query ?? keyword)&display=30&sort=\(sort)&start=\(start)"
        
        let scheme = "https"
        let host = "openapi.naver.com"
        let path = "/v1/search/shop.json"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "query", value: query),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        
        guard let url = component.url else { return }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                if error != nil {
                    print("Failed Request")
                    completionHandler(nil, .failedRequest)
                    return
                }
                
                guard let response = response as? HTTPURLResponse, (200...299).contains(response.statusCode) else {
                    print("상태코드 오류")
                    print((response as? HTTPURLResponse)?.statusCode)
                    completionHandler(nil, .invalidResponse)
                    return
                }
                
                if let data = data, let result = try? JSONDecoder().decode(ProductsInfo.self, from: data) {
                    completionHandler(result, nil)
                }  else {
                    print("Invalid data")
                    completionHandler(nil, .invalidData)
                    return
                }
            }
        }.resume()
    }
}
