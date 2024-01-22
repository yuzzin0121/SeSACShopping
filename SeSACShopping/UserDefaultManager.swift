//
//  UserDefaultManager.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import Foundation

// singleton pattern
// 유일한 인스턴스를 하나만 생성
class UserDefaultManager {
    static let shared = UserDefaultManager()
    
    private init() { }
    
    enum UDKey: String, CaseIterable {
        case UserStatus
        case nickname
        case profileImageIndex
        case searchKeywords
        case likeCount
        case likeProductIds
    }
    
    let ud = UserDefaults.standard
    
    var UserStatus: Bool{
        get { ud.bool(forKey: UDKey.UserStatus.rawValue) }
        set { ud.set(newValue, forKey: UDKey.UserStatus.rawValue) }
    }

    var nickname: String {
        get { ud.string(forKey: UDKey.nickname.rawValue) ?? "" }
        set { ud.set(newValue, forKey: UDKey.nickname.rawValue) }
    }
    
    var profileImageIndex: Int {
        get { ud.integer(forKey: UDKey.profileImageIndex.rawValue) }
        set { ud.set(newValue, forKey: UDKey.profileImageIndex.rawValue) }
    }
    
    var searchKeywords: [String] {
        get { ud.array(forKey: UDKey.searchKeywords.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.searchKeywords.rawValue) }
    }
    
    var likeCount: Int {
        get { ud.integer(forKey: UDKey.likeCount.rawValue) }
        set { ud.set(newValue, forKey: UDKey.likeCount.rawValue) }
    }
    
    var likeProductIds: [String] {
        get { ud.array(forKey: UDKey.likeProductIds.rawValue) as? [String] ?? [] }
        set { ud.set(newValue, forKey: UDKey.likeProductIds.rawValue) }
    }
}


