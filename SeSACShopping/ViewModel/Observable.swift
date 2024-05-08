//
//  Observable.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import Foundation

class Observable<T> {
    var closure: ((T) -> Void)?
    
    var value: T {
        didSet {    // 내용이 달라질 때마다 어떤 기능
            closure?(value)   // 어떠한 함수를 실행
        }
    }
    
    init(_ value: T) {
        self.value = value
    }
    
    func bind(_ closure: @escaping (T) -> Void) {    // 매개변수로 함수를 넣어주고, closure라는 함수를 담는 프로퍼티에 넣어준다.
        print(#function)
        closure(value)
        self.closure = closure
    }
}
