//
//  ProfileImageSettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

class ProfileImageSettingViewController: UIViewController, ViewProtocol {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        designViews() 
    }

    func configureView() {
        navigationItem.title = "프로필 설정"
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
    
    // pop - 시작 화면으로
    @objc func popView() {
        navigationController?.popViewController(animated: true)
    }
    
    func designViews() {
        view.backgroundColor = ColorStyle.backgroundColor
    }
}
