//
//  ProfileImageSettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

class ProfileImageSettingViewController: BaseViewController {
    let mainView = ProfileImageSettingView()
    
    var selectedProfileImageIndex: Int?
    var type: Type = .Onboarding    
    
    var profileList: [Profile] = ProfileImage.profileList   // 프로필 사진들
    var completionHandler: ((Int) -> Void)? // 이미지 전달할 핸들러

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
    }
    
    override func loadView() {
        view = mainView
    }
    
    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"
    
        guard let selectedProfileImageIndex else { return }
        profileList[selectedProfileImageIndex].isSelected = true
        mainView.selectedProfileImageView.image = profileList[selectedProfileImageIndex].profileImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        mainView.selectedProfileImageView.layer.cornerRadius = mainView.selectedProfileImageView.frame.height / 2
    }
    
    // pop - 시작 화면으로
    @objc func popView() {
        if let selectedProfileImageIndex {
            completionHandler!(selectedProfileImageIndex)
        }
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - 디자인
    
    // CollectionView 설정
    func configureCollectionView() {
        mainView.profileImageCollectionView.delegate = self
        mainView.profileImageCollectionView.dataSource = self
        mainView.profileImageCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    
    // navigationItem 설정
    override func configureNavigationItem() {
        navigationItem.title = "프로필 설정"
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
}

// 프로필 사진 리스트
extension ProfileImageSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        profileList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ProfileImageCollectionViewCell.identifier, for: indexPath) as! ProfileImageCollectionViewCell
        
        cell.configureCell(item: profileList[indexPath.row])
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        profileList[selectedProfileImageIndex!].isSelected = false
        selectedProfileImageIndex = indexPath.row
        mainView.selectedProfileImageView.image = profileList[selectedProfileImageIndex!].profileImage
        profileList[indexPath.row].isSelected = true
        mainView.profileImageCollectionView.reloadData()
    }
}
