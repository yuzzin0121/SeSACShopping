//
//  OnboardingView.swift
//  SeSACShopping
//
//  Created by 조유진 on 2/27/24.
//

import UIKit

class OnboardingView: BaseView {
    let onboardingTitleImageView = UIImageView()
    let onboardingImageView = UIImageView()
    let startButton = PointButton()
    
    override func configureHierarchy() {
        [onboardingTitleImageView, onboardingImageView, startButton].forEach {
            addSubview($0)
        }
    }
    
    override func configureLayout() {
        onboardingTitleImageView.snp.makeConstraints { make in
            make.top.equalTo(safeAreaLayoutGuide).offset(16)
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
            make.horizontalEdges.bottom.equalTo(safeAreaLayoutGuide).inset(14)
            make.height.equalTo(44)
        }
        
    }
    
    // 디자인 설정
    override func configureView() {

        // 온보딩 레이블
        onboardingTitleImageView.design(image: ImageStyle.sesacShopping)
        // 온보딩 이미지뷰
        onboardingImageView.design(image: ImageStyle.onboarding)
        // 시작하기 버튼
        startButton.setTitle("시작하기", for: .normal)
    }
}
