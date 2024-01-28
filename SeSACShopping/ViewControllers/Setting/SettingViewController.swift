//
//  SettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

// 설정 화면
class SettingViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var profileBackgroundView: UIView!
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nicknameLabel: UILabel!
    @IBOutlet weak var likeCountLabel: UILabel!
    
    @IBOutlet weak var settingTableView: UITableView!
    
    let settingList: [Setting] = Setting.allCases   // 설정에 보일 내용들
    let profileImages: [Profile] = ProfileImage.profileList
    
    var nickname: String? { // 사용자의 닉네임
        didSet {
            nicknameLabel.text = "떠나고싶은 \(nickname!)"
        }
    }
    
    var profileImageIndex: Int? {   // 사용자의 프로필 사진 인덱스
        didSet {
            profileImageView.image = profileImages[UserDefaultManager.shared.profileImageIndex].profileImage
        }
    }

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        configureNavigationItem()
        configureTableView()
    }
    
    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        let likeCount = UserDefaultManager.shared.likeCount
        likeCountLabel.design(text: "\(likeCount)개의 상품을 좋아하고 있어요!", font: .boldSystemFont(ofSize: 15))
        likeCountLabel.changeTextColor(keyword: "\(likeCount)개의 상품")
        
        profileImageView.image = profileImages[UserDefaultManager.shared.profileImageIndex].profileImage
        nicknameLabel.text = "떠나고싶은 \(UserDefaultManager.shared.nickname)"
    }
    
    // 프로필 클릭했을 때
    @IBAction func profileViewDidTap(_ sender: UITapGestureRecognizer) {
        let NicknameSettingVC = NicknameSettingViewController()
        NicknameSettingVC.type = .Setting
        NicknameSettingVC.nickname = UserDefaultManager.shared.nickname
        NicknameSettingVC.selectedImageIndex = UserDefaultManager.shared.profileImageIndex
        navigationController?.pushViewController(NicknameSettingVC, animated: true)
    }
    
    // navigationItem. tabBar 디자인
    func configureNavigationItem() {
        navigationItem.title = "설정"
        self.tabBarController?.tabBar.unselectedItemTintColor = .gray
        self.tabBarController?.tabBar.tintColor = ColorStyle.pointColor
    }
    
    // TableView 설정
    func configureTableView() {
        navigationController?.setupBarAppearance()
        settingTableView.backgroundColor = ColorStyle.backgroundColor
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.clipsToBounds = true
        settingTableView.layer.cornerRadius = 12
        settingTableView.isScrollEnabled = false
        
    }
    
    func configureHierarchy() {
        
    }
    
    func setupContstraints() {
        
    }
    
    // 뷰 디자인
    func configureView() {
        view.backgroundColor = ColorStyle.backgroundColor
        let index = UserDefaultManager.shared.profileImageIndex
        profileBackgroundView.backgroundColor = ColorStyle.deepDarkGray
        profileBackgroundView.layer.cornerRadius = 12
        
        profileImageView.design(image: profileImages[index].profileImage,
                                cornerRadius: profileImageView.frame.height/2)
        profileImageView.layer.borderColor = ColorStyle.pointColor.cgColor
        profileImageView.layer.borderWidth = 4
        
        let nickname = UserDefaultManager.shared.nickname
        nicknameLabel.design(text: "떠나고싶은 \(nickname)",
                             font: .systemFont(ofSize: 17, weight: .bold))
        
        let likeCount = UserDefaultManager.shared.likeCount
        likeCountLabel.design(text: "\(likeCount)개의 상품을 좋아하고 있어요!", font: .boldSystemFont(ofSize: 15))
        likeCountLabel.changeTextColor(keyword: "\(likeCount)개의 상품")
        
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "SettingCell")!
        
        cell.selectionStyle = .none
        cell.textLabel?.text = settingList[indexPath.row].title
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
