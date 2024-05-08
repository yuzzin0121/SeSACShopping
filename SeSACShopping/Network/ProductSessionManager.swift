//
//  ProductSessionManager.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/7/24.
//

import Foundation

@MainActor
final class ProductSessionManager {
    static let shared = ProductSessionManager()
    
    var session: URLSession!
    typealias CompletionHandler = (ProductsInfo?, NetworkError?) -> Void
    
    private init() { }
    
    // URLSession은 persentEncoding을 자동으로 처리해준다.
    func fetchNaverProduct(keyword: String, sort: String, start: Int = 1, completionHandler: @escaping CompletionHandler) {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(keyword)&display=30&sort=\(sort)&start=\(start)"
        
        let scheme = "https"
        let host = "openapi.naver.com"
        let path = "/v1/search/shop.json"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        
        print(component)
        
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
    
    func fetchNaverProductAsyncAwait(keyword: String, sort: String, start: Int = 1) async throws -> ProductsInfo {
        let url = "https://openapi.naver.com/v1/search/shop.json?query=\(keyword)&display=30&sort=\(sort)&start=\(start)"
        
        let scheme = "https"
        let host = "openapi.naver.com"
        let path = "/v1/search/shop.json"
        
        var component = URLComponents()
        component.scheme = scheme
        component.host = host
        component.path = path
        component.queryItems = [
            URLQueryItem(name: "query", value: keyword),
            URLQueryItem(name: "display", value: "30"),
            URLQueryItem(name: "sort", value: sort),
            URLQueryItem(name: "start", value: "\(start)")
        ]
        
        guard let url = component.url else { throw NetworkError.noData }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "GET"
        request.addValue(APIKey.clientID, forHTTPHeaderField: "X-Naver-Client-Id")
        request.addValue(APIKey.clientSecret, forHTTPHeaderField: "X-Naver-Client-Secret")
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
            throw NetworkError.invalidResponse
        }
        
        guard let result = try? JSONDecoder().decode(ProductsInfo.self, from: data) else {
            throw NetworkError.invalidData
        }
        return result
    }
}
