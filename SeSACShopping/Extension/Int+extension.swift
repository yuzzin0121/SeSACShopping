//
//  Int+extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import Foundation

extension Int {
    func convertPriceString() -> String {
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal
        
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: self)) {
            return formattedNumber 
        }
        
        return String(self)
    }
}
