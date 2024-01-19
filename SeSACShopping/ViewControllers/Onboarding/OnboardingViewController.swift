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
class OnboardingViewController: UIViewController {
    @IBOutlet weak var onboardingLabel: UILabel!
    @IBOutlet weak var onboardingImageView: UIImageView!
    @IBOutlet weak var startButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        designView()
    }
    
    // 시작하기 버튼 클릭 시
    @IBAction func startButtonClicked(_ sender: UIButton) {
        print("시작 버튼 클릭")
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let nicknameSettingVC = MainSB.instantiateViewController(withIdentifier: NicknameSettingViewController.identifier) as! NicknameSettingViewController
        
        navigationController?.pushViewController(nicknameSettingVC, animated: true)
    }
    
    // 디자인 설정
    func designView() {
        // 슈퍼뷰
        view.backgroundColor = ColorStyle.backgroundColor
        navigationController?.setupBarAppearance()
        // 온보딩 레이블
        onboardingLabel.design(text: "SeSAC\nShopping",
                               textColor: ColorStyle.pointColor,
                               font: .systemFont(ofSize: 40, weight: .black),
                               textAlignment: .center,
                               numberOfLines: 2)
        // 온보딩 이미지뷰
        onboardingImageView.design(image: ImageStyle.onboarding)
        // 시작하기 버튼
        startButton.design(title: "시작하기",
                                 titleColor: ColorStyle.textColor,
                                 backgroundColor:ColorStyle.pointColor,
                                 cornerRadius: 8)
    }

}
