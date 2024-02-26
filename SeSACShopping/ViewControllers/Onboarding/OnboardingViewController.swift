//
//  OnboardingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

// 앱을 최초로 실행했을 때 보여지는 화면
// 1. 프로필 닉네임 설정 화면에서 아직 프로필을 설정하지 않은 경우
// 2. 설정 화면에서 처음부터 시작하기 셀을 클릭한 경우
class OnboardingViewController: BaseViewController {
    let mainView = OnboardingView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainView.startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    override func loadView() {
        view = mainView
    }
    
    // 시작하기 버튼 클릭 시
    @objc func startButtonClicked(_ sender: UIButton) {
        let nicknameSettingVC = NicknameSettingViewController()
        nicknameSettingVC.type = .Onboarding
        
        navigationController?.pushViewController(nicknameSettingVC, animated: true)
    }
}
