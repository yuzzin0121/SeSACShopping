//
//  NicknameSettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

// 프로필 닉네임 설정 화면
/*
1. 프로필 이미지 👍🏻
 - 처음 진입 시 이미지 랜덤 설정 (profile1~profile14)
 - 프로필 이미지 영역 클릭 시 [프로필 이미지 설정 화면]으로 Push
2. 닉네임 👍🏻
 - 1: 2글자 이상 10글자 미만 / 2: 4개의 특수문자(@,#,$,%) 및 숫자 사용 불가
 - 실시간으로 달라지는 닉네임 텍스트에 따라 상태 레이블이 변경 (경고 문자)
3. 상태 레이블 👍🏻
 - 조건에 맞는 경우: "사용할 수 있는 닉네임이에요"
 - 글자수 조건에 맞지 않는 경우: "2글자 이상 10글자 미만으로 설정해주세요"
 - 특수문자 조건에 맞지 않는 경우: "닉네임에 @, #, $, %는 포함할 수 없어요"
 - 숫자 조건에 맞지 않는 경우: "닉네임에 숫자는 포함할 수 없어요"
4. 완료 버튼 👍🏻
 - 조건에 맞게 닉네임이 정상적으로 설정한 경우 -> Window RootView Controller가 [메인 화면]으로 교체된다
 - 닉네임이 조건에 맞게 설정되지 않은 경우, 화면 전환 불가능
5. < 클릭시 👍🏻
 - 온보딩 화면으로 pop
 - 이 때, 현재 사용자가 선택한 프로필 이미지와 입력한 닉네임 텍스트는 초기화된다.
 */

// MARK: - 완료

class NicknameSettingViewController: UIViewController, ViewProtocol {
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var cameraImageView: UIImageView!
    @IBOutlet weak var nicknameTextField: UITextField!
    @IBOutlet weak var textFieldUnderLine: UIView!
    @IBOutlet weak var statusLabel: UILabel!
    @IBOutlet weak var finishButton: UIButton!
    
    
    lazy var profileList: [Profile] = ProfileImage.profileList
    var type: Type = .Setting
    var selectedImageIndex: Int? = nil
    var nickname: String? = nil
    var isValid: Bool = false
    var completionHandler: ((String, Int) -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(#function)
        configureView()
        selectedImageIndex = getRandomImageIndex()
        profileImageView.image = profileList[selectedImageIndex!].profileImage
        designViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print(#function)
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"
        if type == .Setting {
            nickname = UserDefaultManager.shared.nickname
            nicknameTextField.text = UserDefaultManager.shared.nickname
            isValid = true
        }
        let index = UserDefaultManager.shared.profileImageIndex
        profileImageView.image = profileList[index].profileImage
    }
    
    // 프로필 사진 클릭했을 때
    @IBAction func profileImageClicked(_ sender: UITapGestureRecognizer) {
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let ProfileImageSettingVC = MainSB.instantiateViewController(withIdentifier: ProfileImageSettingViewController.identifier) as! ProfileImageSettingViewController
        ProfileImageSettingVC.type = self.type
        navigationController?.pushViewController(ProfileImageSettingVC, animated: true)
    }
    
    // 완료 버튼 클릭했을 때
    @IBAction func finishButtonClicked(_ sender: UIButton) {
        print("click")
        print(isValid)
        print(type == .Setting)
        if isValid && type == .Onboarding { // 이전 화면이 온보딩 화면일 경우
            guard let nickname = nickname else { return }
            UserDefaultManager.shared.nickname = nickname
            UserDefaultManager.shared.UserStatus = true
            let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
            let sceneDelegate = windowScene?.delegate as? SceneDelegate
            let MainSB = UIStoryboard(name: "Main", bundle: nil)
            let tabC = MainSB.instantiateViewController(identifier: "MainTabBarController") as! UITabBarController
            sceneDelegate?.window?.rootViewController = tabC
            sceneDelegate?.window?.makeKeyAndVisible()
        } else if isValid && type == .Setting { // 이전 화면이 설정 화면일 경우
            guard let nickname = nickname else { return }
            UserDefaultManager.shared.nickname = nickname
            print("Setting")
            UserDefaultManager.shared.UserStatus = true
            self.completionHandler?(nickname, UserDefaultManager.shared.profileImageIndex)
            navigationController?.popViewController(animated: true)
        } else {
            print("닉네임 조건 불일치")
        }
    }
    
    // 닉네임 텍스트필드 내용 변경 시
    @IBAction func nicknameEditingChanged(_ sender: UITextField) {
        let text = sender.text!
        
        if isLengValid(nickname: text) == false {
            statusLabel.text = "2글자 이상 10글자 미만으로 설정해주세요"
            isValid = false
        } else if isNotSpecialChars(nickname: text) {
            statusLabel.text = "닉네임에 @, #, $, %는 포함할 수 없어요"
            isValid = false
        } else if isNotNumber(nickname: text){
            statusLabel.text = "닉네임에 숫자는 포함할 수 없어요"
            isValid = false
        } else {
            statusLabel.text = "사용할 수 있는 닉네임이에요"
            isValid = true
            nickname = text
        }
    }
    
    // 글자수 체크 (2~9)
    func isLengValid(nickname: String) -> Bool {
        if nickname.isEmpty { return false }
        let pattern = "^.{2,9}$"
        let isMatch = nickname.range(of: pattern, options: .regularExpression) != nil
        return isMatch
//        let pred = NSPredicate(format: "SELF MATCHES %@", pattern)
//        print(pred.evaluate(with: nickname))
//        return pred.evaluate(with: nickname)
    }
    
    // 특수문자 체크 (@,#,$,%) X
    func isNotSpecialChars(nickname: String) -> Bool {
        if nickname.isEmpty { return false }
        let pattern = "^[^@#$%]*$"
        let isMatch = nickname.range(of: pattern, options: .regularExpression) == nil
        
        return isMatch
    }
    
    // 숫자 불가능 체크
    func isNotNumber(nickname: String) -> Bool {
        if nickname.isEmpty { return false }
        let pattern = "^[^0-9]*$"
        let isMatch = nickname.range(of: pattern, options: .regularExpression) == nil
        return isMatch
    }
    
    func configureView() {
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
    
    // pop - 시작 화면으로
    @objc func popView() {
        selectedImageIndex = nil
        nickname = nil
        navigationController?.popViewController(animated: true)
    }
    
    // 뷰 디자인
    func designViews() {
        navigationController?.setupBarAppearance()
        view.backgroundColor = ColorStyle.backgroundColor
        profileImageView.isUserInteractionEnabled = true
        profileImageView.design(image: nil,
                                cornerRadius: profileImageView.frame.height/2)
        profileImageView.layer.borderWidth = 4
        profileImageView.layer.borderColor = ColorStyle.pointColor.cgColor
        cameraImageView.design(image: ImageStyle.camera,
                               cornerRadius: cameraImageView.frame.height/2)
        nicknameTextField.design(placeholder: "닉네임을 입력해주세요:)",
                                 cornerRadius: 12)
        
        textFieldUnderLine.backgroundColor = ColorStyle.textColor
        statusLabel.design(text: "", textColor: ColorStyle.pointColor, font: .systemFont(ofSize: 13))
        
        finishButton.design(title: "완료",
                            cornerRadius: 8)
        
    }
    
    // 랜덤으로 프로필 이미지 가져오기
    func getRandomImageIndex() -> Int {
        return .random(in: 0...profileList.count - 1)
    }

}
