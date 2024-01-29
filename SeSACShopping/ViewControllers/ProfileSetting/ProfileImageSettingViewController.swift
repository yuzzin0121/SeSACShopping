//
//  ProfileImageSettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

class ProfileImageSettingViewController: UIViewController, ViewProtocol {
    let selectedProfileImageView = ProfileImageView(frame: .zero)
    lazy var profileImageCollectionView = UICollectionView(frame: .zero, collectionViewLayout: configureCollectionViewFlowLayout())
    
    var selectedProfileImageIndex: Int?
    var type: Type = .Onboarding    
    
    var profileList: [Profile] = ProfileImage.profileList   // 프로필 사진들
    var completionHandler: ((Int) -> Void)? // 이미지 전달할 핸들러

    // MARK: - viewDidLoad()
    override func viewDidLoad() {
        super.viewDidLoad()
        configureHierarchy()
        configureView()
        configureCollectionView()
        configureLayout()
        configureNavigationItem()
    }
    
    // MARK: - viewWillAppear()
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"
    
        guard let selectedProfileImageIndex else { return }
        profileList[selectedProfileImageIndex].isSelected = true
        selectedProfileImageView.image = profileList[selectedProfileImageIndex].profileImage
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        selectedProfileImageView.layer.cornerRadius = selectedProfileImageView.frame.height / 2
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
        profileImageCollectionView.delegate = self
        profileImageCollectionView.dataSource = self
        profileImageCollectionView.register(ProfileImageCollectionViewCell.self, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
    }
    
    func configureCollectionViewFlowLayout() -> UICollectionViewFlowLayout {
        let flowLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 36
        let cellWidth = (UIScreen.main.bounds.width - spacing*2) / 4
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
        flowLayout.scrollDirection = .vertical
        return flowLayout
    }
    
    // navigationItem 설정
    func configureNavigationItem() {
        navigationItem.title = "프로필 설정"
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
    
    func configureHierarchy() {
        [selectedProfileImageView, profileImageCollectionView].forEach {
            view.addSubview($0)
        }
    }
    
    func configureLayout() {
        selectedProfileImageView.snp.makeConstraints { make in
            make.top.equalTo(view.safeAreaLayoutGuide).offset(24)
            make.centerX.equalToSuperview()
            make.size.equalTo(100)
        }
        
        profileImageCollectionView.snp.makeConstraints { make in
            make.top.equalTo(selectedProfileImageView.snp.bottom).offset(36)
            make.horizontalEdges.bottom.equalTo(view.safeAreaLayoutGuide)
        }
    }
    
    // 뷰 디자인
    func configureView() {
        navigationController?.setupBarAppearance()
        view.backgroundColor = ColorStyle.backgroundColor
        
        profileImageCollectionView.backgroundColor = ColorStyle.backgroundColor
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
        selectedProfileImageView.image = profileList[selectedProfileImageIndex!].profileImage
        profileList[indexPath.row].isSelected = true
        profileImageCollectionView.reloadData()
    }
}
