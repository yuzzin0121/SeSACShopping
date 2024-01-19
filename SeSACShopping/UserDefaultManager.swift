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
    
    enum UDKey: String {
        case UserStatus
        case nickname
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
}


