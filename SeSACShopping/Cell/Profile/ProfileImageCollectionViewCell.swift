//
//  ProfileImageCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/19/24.
//

import UIKit

class ProfileImageCollectionViewCell: UICollectionViewCell, CellProtocol {
    
    @IBOutlet weak var profileImageView: UIImageView!
    var isClicked = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func draw(_ rect: CGRect) {
        profileImageView.clipsToBounds = true
        profileImageView.layer.cornerRadius = profileImageView.frame.height / 2
    }
    
    func configureCell(item: Any) {
        let profile = item as! Profile
        profileImageView.image = profile.profileImage
        isBorder(status: profile.isSelected)
    }
    
    func isBorder(status: Bool) {
        profileImageView.layer.borderWidth = status ? 4 : 0
        profileImageView.layer.borderColor = status ? ColorStyle.pointColor.cgColor : UIColor.clear.cgColor
    }
}
