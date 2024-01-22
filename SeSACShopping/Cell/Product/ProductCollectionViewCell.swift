//
//  ProductCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell, CellProtocol {
    
    @IBOutlet weak var productImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var mallNameLabel: UILabel!
    @IBOutlet weak var lpriceLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    var isLike:Bool = false {
        didSet {
            let image = (isLike == true) ? ImageStyle.likeFill : ImageStyle.like
            likeButton.setImage(image, for: .normal)
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        titleLabel.design(textColor: .gray, 
                          font: .systemFont(ofSize: 13), numberOfLines: 2)
        mallNameLabel.design(font: .systemFont(ofSize: 14, weight: .semibold))
        lpriceLabel.design(font: .boldSystemFont(ofSize: 16))
    }
    
    override func draw(_ rect: CGRect) {
        productImageView.design(cornerRadius: 14)
        likeButton.design(image: ImageStyle.like,
                          tintColor: ColorStyle.backgroundColor,
                          backgroundColor: ColorStyle.textColor,
                          cornerRadius: likeButton.frame.height/2)
    }

    func configureCell(item: Any) {
        let product = item as! Product
        
        if let imageString = product.productItem.image {
            let url: URL = URL(string: imageString)!
            productImageView.kf.setImage(with: url, placeholder: ImageStyle.empty)
        } else {
            productImageView.image = ImageStyle.empty
        }
        let title = product.productItem.title.htmlEscaped
        titleLabel.text = title
        mallNameLabel.text = product.productItem.mallName
        let price = Int(product.productItem.lprice)!
        lpriceLabel.text = "\(price.convertPriceString())원"
        
        let heartImage = product.isLike == true ? ImageStyle.likeFill : ImageStyle.like
        likeButton.setImage(heartImage, for: .normal)
    }
}
