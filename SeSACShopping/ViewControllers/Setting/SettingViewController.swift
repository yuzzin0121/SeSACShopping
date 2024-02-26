//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

// 설정 화면
class SettingViewController: BaseViewController {
    let mainView = SettingView()
    
    let settingList: [Setting] = Setting.allCases   // 설정에 보일 내용들
    let profileImages: [Profile] = ProfileImage.profileList
    
    var nickname: String? { // 사용자의 닉네임
        didSet {
            mainView.nicknameLabel.text = "떠나고싶은 \(nickname!)"
        }
    }
    
    var profileImageIndex: Int? {   // 사용자의 프로필 사진 인덱스
        didSet {
            mainView.profileImageView.image = profileImages[UserDefaultManager.shared.profileImageIndex].profileImage
        }
    }

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        configureView()
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileViewDidTap))
        mainView.profileBackgroundView.addGestureRecognizer(tapGesture)
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let likeCount = UserDefaultManager.shared.likeCount
        mainView.likeCountLabel.text = "\(likeCount)개의 상품을 좋아하고 있어요!"
        mainView.likeCountLabel.changeTextColor(keyword: "\(likeCount)개의 상품")
        
        mainView.profileImageView.image = profileImages[UserDefaultManager.shared.profileImageIndex].profileImage
        mainView.nicknameLabel.text = "떠나고싶은 \(UserDefaultManager.shared.nickname)"
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        DispatchQueue.main.async {
            self.mainView.profileImageView.layer.cornerRadius = self.mainView.profileImageView.frame.height / 2
        }
    }
    
    // 프로필 클릭했을 때
    @objc func profileViewDidTap(_ sender: UITapGestureRecognizer) {
        let NicknameSettingVC = NicknameSettingViewController()
        NicknameSettingVC.type = .Setting
        NicknameSettingVC.nickname = UserDefaultManager.shared.nickname
        NicknameSettingVC.selectedImageIndex = UserDefaultManager.shared.profileImageIndex
        navigationController?.pushViewController(NicknameSettingVC, animated: true)
    }
    
    // navigationItem. tabBar 디자인
    override func configureNavigationItem() {
        navigationItem.title = "설정"
        self.tabBarController?.tabBar.unselectedItemTintColor = .gray
        self.tabBarController?.tabBar.tintColor = ColorStyle.pointColor
    }
    
    // TableView 설정
    func configureTableView() {
        mainView.settingTableView.delegate = self
        mainView.settingTableView.dataSource = self
        mainView.settingTableView.backgroundColor = ColorStyle.backgroundColor
    }
    
    func configureView() {
        let index = UserDefaultManager.shared.profileImageIndex
        mainView.profileImageView.image = profileImages[index].profileImage
    }
    
    // 처음으로 돌아가기 클릭 시 리셋
    func reset() {
        let shared = UserDefaultManager.shared
        let udKeys = UserDefaultManager.UDKey.allCases
        udKeys.forEach {
            shared.ud.removeObject(forKey: $0.rawValue)
        }
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let OnboardingVC = OnboardingViewController()
        
        let nav = UINavigationController(rootViewController: OnboardingVC)  // 온보딩 화면으로
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
}

extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        settingList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.selectionStyle = .none
        cell.textLabel?.text = settingList[indexPath.row].title
        cell.textLabel?.font = .systemFont(ofSize: 14)
        cell.textLabel?.textColor = ColorStyle.textColor
        cell.backgroundColor = ColorStyle.deepDarkGray
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == Setting.startBeginAgain.rawValue {  // 클릭 시 alert 띄우기
            showAlert(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?", buttonTitle: "확인") {
                self.reset()
            }
        }
    }
}
