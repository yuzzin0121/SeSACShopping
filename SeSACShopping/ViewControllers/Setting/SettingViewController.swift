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
    
    let settingList: [Setting] = Setting.allCases
    let profileImages: [Profile] = ProfileImage.profileList
    
    var nickname: String? {
        didSet {
            nicknameLabel.text = "떠나고싶은 \(nickname!)"
        }
    }
    
    var profileImageIndex: Int? {
        didSet {
            profileImageView.image = profileImages[profileImageIndex ?? 0].profileImage
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        configureView()
        designViews()
        configureTableView()
    }
    
    @IBAction func profileViewDidTap(_ sender: UITapGestureRecognizer) {
        let MainSB = UIStoryboard(name: "Main", bundle: nil)
        let NicknameSettingVC = MainSB.instantiateViewController(withIdentifier: NicknameSettingViewController.identifier) as! NicknameSettingViewController
        NicknameSettingVC.type = .Setting
        NicknameSettingVC.completionHandler = { nickname, index in
            self.nickname = nickname
            self.profileImageIndex = index
        }
        navigationController?.pushViewController(NicknameSettingVC, animated: true)
    }
    
    func configureView() {
        navigationItem.title = "설정"
        self.tabBarController?.tabBar.unselectedItemTintColor = .gray
        self.tabBarController?.tabBar.tintColor = ColorStyle.pointColor
    }
    
    func configureTableView() {
        navigationController?.setupBarAppearance()
        settingTableView.backgroundColor = ColorStyle.backgroundColor
        settingTableView.delegate = self
        settingTableView.dataSource = self
        settingTableView.clipsToBounds = true
        settingTableView.layer.cornerRadius = 12
        settingTableView.isScrollEnabled = false
        
    }
    
    func designViews() {
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
    
    func reset() {
        let shared = UserDefaultManager.shared
        shared.ud.removeObject(forKey: UserDefaultManager.UDKey.UserStatus.rawValue)
        shared.ud.removeObject(forKey: UserDefaultManager.UDKey.nickname.rawValue)
        shared.ud.removeObject(forKey: UserDefaultManager.UDKey.profileImageIndex.rawValue)
        shared.ud.removeObject(forKey: UserDefaultManager.UDKey.likeCount.rawValue)
        
        let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene
        let sceneDelegate = windowScene?.delegate as? SceneDelegate
        let OnboardingSB = UIStoryboard(name: "Onboarding", bundle: nil)
        let OnboardingVC = OnboardingSB.instantiateViewController(identifier: OnboardingViewController.identifier) as! OnboardingViewController
        
        let nav = UINavigationController(rootViewController: OnboardingVC)
        sceneDelegate?.window?.rootViewController = nav
        sceneDelegate?.window?.makeKeyAndVisible()
    }
    
    func alert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        let confirm = UIAlertAction(title: "확인", style: .destructive) { UIAlertAction in
            self.reset()
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(confirm)
        alert.addAction(cancelAction)
        present(alert, animated: true)
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
        if indexPath.row == Setting.startBeginAgain.rawValue {
            alert(title: "처음부터 시작하기", message: "데이터를 모두 초기화하시겠습니까?")
        }
    }
}