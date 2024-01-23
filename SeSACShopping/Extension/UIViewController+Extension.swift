//
//  UIViewController+Extension.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/24/24.
//

import UIKit

extension UIViewController {
    
    // 버튼을 눌렀을 때 처리할 기능을 매개변수로 넘겨주기
    func showAlert(
        title: String,
        message: String,
        buttonTitle: String,
        completionHandler: @escaping () -> Void)
    {
        let alert = UIAlertController(title: title,
                                      message: message,
                                      preferredStyle: .alert)
        
        let action = UIAlertAction(title: buttonTitle, style: .default) { _ in
            completionHandler()
        }
        let cancel = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(cancel)
        alert.addAction(action)
        
        present(alert, animated: true)
    }
}
