//
//  Protocol.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

protocol ReuseProtocol {
    static var identifier: String { get }
}

protocol TableViewCellProtocol {
    func configureCell(item: Any)
}

// MARK: - extension
extension UITableViewCell: ReuseProtocol {
    static var identifier: String {
        get {
            String(describing: self)
        }
    }
}

extension UICollectionViewCell: ReuseProtocol {
    static var identifier: String {
        get {
            String(describing: self)
        }
    }
}

extension UIViewController: ReuseProtocol {
    static var identifier: String {
        get {
            String(describing: self)
        }
    }
}
