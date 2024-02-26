//
//  BaseViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class BaseViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
    }
    
    func configureNavigationItem() {
        navigationController?.setupBarAppearance()
    }
    
    // 메인 탭바로 화면 전환
    func showMainTabBar() {
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let tabC = MainSB.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
        sceneDelegate?.window?.rootViewController = tabC
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

