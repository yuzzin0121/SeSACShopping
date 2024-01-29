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
class OnboardingViewController: UIViewController, ViewProtocol {
    
    let onboardingTitleImageView = UIImageView()
    let onboardingImageView = UIImageView()
    let startButton = PointButton()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureLayout()
        startButton.addTarget(self, action: #selector(startButtonClicked), for: .touchUpInside)
    }
    
    // 시작하기 버튼 클릭 시
    @objc func startButtonClicked(_ sender: UIButton) {
        let nicknameSettingVC = NicknameSettingViewController()
        nicknameSettingVC.type = .Onboarding
        
        navigationController?.pushViewController(nicknameSettingVC, animated: true)
    }
    
    func configureHierarchy() {
        [onboardingTitleImageView, onboardingImageView, startButton].forEach {
            view.addSubview($0)
        }
    }
    
    func configureLayout() {
        onboardingTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(16)
            make.centerX.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(150)
        }
        
        onboardingImageView.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.horizontalEdges.equalToSuperview().inset(32)
            make.height.equalTo(UIScreen.main.bounds.height * 0.3)
        }
        
        startButton.snp.makeConstraints { make in
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide).inset(14)
            make.height.equalTo(44)
        }
        
    }
    
    // 디자인 설정
    func configureView() {
        // 슈퍼뷰
        view.backgroundColor = ColorStyle.backgroundColor
        navigationController?.setupBarAppearance()
        // 온보딩 레이블
        onboardingTitleImageView.design(image: ImageStyle.sesacShopping)
        // 온보딩 이미지뷰
        onboardingImageView.design(image: ImageStyle.onboarding)
        // 시작하기 버튼
        startButton.setTitle("시작하기", for: .normal)
    }

}
