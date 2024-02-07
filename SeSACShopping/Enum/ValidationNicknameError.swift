//
//  ValidationNicknameError.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/7/24.
//

import Foundation

enum ValidationNicknameError: Error {
    case invalidateLength
    case isSpecialChars
    case isNumber
    
    var message: String {
        switch self {
        case .invalidateLength:
            return "2글자 이상 10글자 미만으로 설정해주세요"
        case .isSpecialChars:
            return "닉네임에 @, #, $, %는 포함할 수 없어요"
        case .isNumber:
            return "닉네임에 숫자는 포함할 수 없어요"
        }
    }
}
