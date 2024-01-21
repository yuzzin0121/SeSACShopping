//
//  ProfileImageSettingViewController.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

class ProfileImageSettingViewController: UIViewController, ViewProtocol {
    @IBOutlet weak var selectedProfileImageView: UIImageView!
    @IBOutlet weak var profileImageCollectionView: UICollectionView!
    var selectedProfileImageIndex: Int?
    var type: Type = .Onboarding
    
    var profileList: [Profile] = ProfileImage.profileList

    override func viewDidLoad() {
        super.viewDidLoad()
        configureView()
        designViews() 
        configureCollectionView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        navigationItem.title = (type == .Onboarding) ? "프로필 설정" : "프로필 수정"
        selectedProfileImageIndex = UserDefaultManager.shared.profileImageIndex
        guard let selectedProfileImageIndex else { return }
        profileList[selectedProfileImageIndex].isSelected = true
        selectedProfileImageView.image = profileList[selectedProfileImageIndex].profileImage
    }
    
    func configureCollectionView() {
        profileImageCollectionView.delegate = self
        profileImageCollectionView.dataSource = self
        let profileNib = UINib(nibName: ProfileImageCollectionViewCell.identifier, bundle: nil)
        profileImageCollectionView.register(profileNib, forCellWithReuseIdentifier: ProfileImageCollectionViewCell.identifier)
        
        let flowLayout = UICollectionViewFlowLayout()
        let spacing: CGFloat = 36
        let cellWidth = (UIScreen.main.bounds.width - spacing*2) / 4
        
        flowLayout.itemSize = CGSize(width: cellWidth, height: cellWidth)
        flowLayout.sectionInset = UIEdgeInsets(top: 12, left: 12, bottom: 12, right: 12)
//        flowLayout.minimumLineSpacing = spacing
//        flowLayout.minimumInteritemSpacing = spacing
        flowLayout.scrollDirection = .vertical
        profileImageCollectionView.collectionViewLayout = flowLayout
    }

    func configureView() {
        navigationItem.title = "프로필 설정"
        navigationItem.hidesBackButton = true
        let backItem = UIBarButtonItem(image: ImageStyle.back, style: .plain, target: self, action: #selector(popView))
        navigationItem.leftBarButtonItem = backItem
    }
    
    // pop - 시작 화면으로
    @objc func popView() {
        UserDefaultManager.shared.profileImageIndex = selectedProfileImageIndex ?? .random(in: 0...profileList.count - 1)
        navigationController?.popViewController(animated: true)
    }
    
    func designViews() {
        navigationController?.setupBarAppearance()
        view.backgroundColor = ColorStyle.backgroundColor
        
        selectedProfileImageView.design(image: nil,
                                cornerRadius: selectedProfileImageView.frame.height/2)
        selectedProfileImageView.layer.borderWidth = 4
        selectedProfileImageView.layer.borderColor = ColorStyle.pointColor.cgColor
        
        profileImageCollectionView.backgroundColor = ColorStyle.backgroundColor
    }
}

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
