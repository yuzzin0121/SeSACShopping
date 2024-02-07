//
//  NicknameSettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/18/24.
//

import UIKit

// 프로필 닉네임 설정 화면

class NicknameSettingViewController: UIViewController, ViewProtocol {
    let profileImageView = ProfileImageView(frame: .zero)
    let cameraImageView = UIImageView()
    let nicknameTextField = UITextField()
    let textFieldUnderLine = UIView()
    let statusLabel = UILabel()
    let finishButton = PointButton()
    
    lazy var profileList: [Profile] = ProfileImage.profileList
    var type: Type = .Setting   // 이전 화면의 타입
    var selectedImageIndex: Int?    // 선택된 프로필 이미지의 인덱스
    var nickname: String? = nil // 사용자 닉네임
    var isValid: Bool = false   // 닉네임 유효성 여부
    var completionHandler: ((String, Int) -> Void)? // 전달할 닉네임과 프로필 이미지 인덱스 핸들러
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureNavigationItem()
        configureHierarchy()
        configureView()
        configureLayout()
        setData()
        hideKeyboardWhenTappedAround()
        let tabGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageClicked))
        profileImageView.addGestureRecognizer(tabGesture)
        nicknameTextField.addTarget(self, action: #selector(nicknameEditingChanged), for: .editingChanged)
        finishButton.addTarget(self, action: #selector(finishButtonClicked), for: .touchUpInside)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"  // 네비게이션아이템 타이틀 설정
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    func setData() {
        if type == .Onboarding {    // 이전 화면이 온보딩 화면일 경우
            selectedImageIndex = getRandomImageIndex()  // 랜덤 프로필 이미지 설정
            if let selectedImageIndex {
                self.profileImageView.image = profileList[selectedImageIndex].profileImage
            }
        }
        if type == .Setting {   // 이전 화면이 설정 화면일 경우
            nicknameTextField.text = nickname
            if let selectedImageIndex {
                self.profileImageView.image = profileList[selectedImageIndex].profileImage
            }
            
            isValid = true
        }
    }
    
    // 프로필 사진 클릭했을 때
    @objc func profileImageClicked(_ sender: UITapGestureRecognizer) {
        let ProfileImageSettingVC = ProfileImageSettingViewController()
        ProfileImageSettingVC.type = self.type
        ProfileImageSettingVC.selectedProfileImageIndex = selectedImageIndex
        ProfileImageSettingVC.completionHandler = { index in
            self.selectedImageIndex = index // 인덱스 전달받기
            self.profileImageView.image = self.profileList[index].profileImage
        }
        navigationController?.pushViewController(ProfileImageSettingVC, animated: true)
    }
    
    // 완료 버튼 클릭했을 때
    @objc func finishButtonClicked(_ sender: UIButton) {
        if isValid && type == .Onboarding { // 이전 화면이 온보딩 화면일 경우
            setInfo()
            showMainTabBar()
        } else if isValid && type == .Setting { // 이전 화면이 설정 화면일 경우
            setInfo()
            self.completionHandler?(nickname!, selectedImageIndex!)
            navigationController?.popViewController(animated: true)
        } else {
            print("닉네임 조건 불일치")
        }
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
    
    // 닉네임, 프로필 이미지, UserStatus 저장
    func setInfo() {
        guard let nickname = nickname else { return }
        UserDefaultManager.shared.nickname = nickname
        UserDefaultManager.shared.UserStatus = true
        UserDefaultManager.shared.profileImageIndex = selectedImageIndex!
    }
    
    func hideKeyboardWhenTappedAround() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // 닉네임 텍스트필드 내용 변경 시
    @objc func nicknameEditingChanged(_ sender: UITextField) {
        guard let text = sender.text else { return }
        
        do {
            let result = try validateNicknameInputError(text: text)
            statusLabel.text = "사용할 수 있는 닉네임이에요"
            isValid = true
            nickname = text
        } catch {
            switch error {
            case ValidationNicknameError.invalidateLength:
                statusLabel.text = ValidationNicknameError.invalidateLength.message
            case ValidationNicknameError.isSpecialChars:
                statusLabel.text = ValidationNicknameError.isSpecialChars.message
            case ValidationNicknameError.isNumber:
                statusLabel.text = ValidationNicknameError.isNumber.message
            default:
                statusLabel.text = "사용할 수 없는 닉네임입니다."
            }
            isValid = false
        }
    }
    
    func validateNicknameInputError(text: String) throws -> Bool {
        guard isLengValid(nickname: text) else {
            throw ValidationNicknameError.invalidateLength
        }
        
        guard !isNotSpecialChars(nickname: text) else {
            throw ValidationNicknameError.isSpecialChars
        }
        
        guard !isNotNumber(nickname: text) else {
            throw ValidationNicknameError.isNumber
        }
        
        return true
    }
    
    // 글자수 체크 (2~9)
    func isLengValid(nickname: String) -> Bool {
        if nickname.isEmpty { return false }
        let pattern = "^.{2,9}$"
        let isMatch = nickname.range(of: pattern, options: .regularExpression) != nil
        return isMatch
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
    
    
    func configureNavigationItem() {
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
    
    // pop - 시작 화면으로
    @objc func popView() {
        if type == .Onboarding {    // 이전 화면이 온보딩 화면일 경우
            selectedImageIndex = nil
            nickname = nil
            UserDefaultManager.shared.ud.removeObject(forKey: UserDefaultManager.UDKey.profileImageIndex.rawValue)
        } else {    // 이전 화면이 설정 화면일 경우
            selectedImageIndex = UserDefaultManager.shared.profileImageIndex
            nickname = UserDefaultManager.shared.nickname
        }
        navigationController?.popViewController(animated: true)
    }
  
    func configureHierarchy() {
        [profileImageView, cameraImageView, nicknameTextField, textFieldUnderLine, statusLabel, finishButton].forEach {
            view.addSubview($0)
        }
        
    }
    
    func configureView() {
        navigationController?.setupBarAppearance()
        view.backgroundColor = ColorStyle.backgroundColor
        
        cameraImageView.design(image: ImageStyle.camera,
                               cornerRadius: cameraImageView.frame.height/2)
        nicknameTextField.design(placeholder: "닉네임을 입력해주세요:)",
                                 cornerRadius: 12)
        
        textFieldUnderLine.backgroundColor = ColorStyle.textColor
        statusLabel.design(text: "", textColor: ColorStyle.pointColor, font: .systemFont(ofSize: 13))
        
        finishButton.setTitle("완료", for: .normal)
    }
    
    func configureLayout() {
        profileImageView.snp.makeConstraints { make in
            make.size.equalTo(100)
            make.top.equalTo(view.safeAreaLayoutGuide).offset(50)
            make.centerX.equalToSuperview()
        }
        cameraImageView.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(profileImageView)
            make.size.equalTo(30)
        }
        
        nicknameTextField.snp.makeConstraints { make in
            make.top.equalTo(profileImageView.snp.bottom).offset(24)
            make.horizontalEdges.equalToSuperview().inset(24)
            make.height.equalTo(44)
        }
        textFieldUnderLine.snp.makeConstraints { make in
            make.top.equalTo(nicknameTextField.snp.bottom)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(1)
        }
        
        statusLabel.snp.makeConstraints { make in
            make.top.equalTo(textFieldUnderLine.snp.bottom).offset(12)
            make.horizontalEdges.equalToSuperview().inset(28)
            make.height.equalTo(20)
        }
        finishButton.snp.makeConstraints { make in
            make.top.equalTo(statusLabel.snp.bottom).offset(28)
            make.horizontalEdges.equalTo(nicknameTextField)
            make.height.equalTo(44)
        }
    }
    
    // 랜덤으로 프로필 이미지 가져오기
    func getRandomImageIndex() -> Int {
        return .random(in: 0...profileList.count - 1)
    }

}
