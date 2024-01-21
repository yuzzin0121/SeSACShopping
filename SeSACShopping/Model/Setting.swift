//
//  Setting.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/20/24.
//

import Foundation

enum Setting: Int, CaseIterable {
    case notice
    case qna
    case oneOnOneQ
    case alarmSetting
    case startBeginAgain
    
    var title: String {
        switch self {
        case .notice: return "공지사항"
        case .qna: return "자주 묻는 질문"
        case .oneOnOneQ: return "1:1문의"
        case .alarmSetting: return "알림 설정"
        case .startBeginAgain: return "처음부터 시작하기"
        }
    }
}
