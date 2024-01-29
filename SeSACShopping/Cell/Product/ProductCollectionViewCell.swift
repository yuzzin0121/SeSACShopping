//
//  ProductCollectionViewCell.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import UIKit
import Kingfisher

class ProductCollectionViewCell: UICollectionViewCell, CellProtocol, ViewProtocol {
    
    let productImageView = UIImageView()
    let titleLabel = UILabel()
    let mallNameLabel = UILabel()
    let lpriceLabel = UILabel()
    let likeButton = UIButton()
    
    var isLike:Bool = false {
        didSet {
            let image = (isLike == true) ? ImageStyle.likeFill : ImageStyle.like
            likeButton.setImage(image, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureHierarchy()
        configureLayout()
        configureView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        productImageView.design(cornerRadius: 14)
        likeButton.design(image: ImageStyle.like,
                          tintColor: ColorStyle.backgroundColor,
                          backgroundColor: ColorStyle.textColor,
                          cornerRadius: likeButton.frame.height/2)
    }
    
    func configureHierarchy() {
        [productImageView, titleLabel, mallNameLabel, lpriceLabel].forEach {
            contentView.addSubview($0)
        }
        productImageView.addSubview(likeButton)
    }
    
    func configureView() {
        titleLabel.design(textColor: .gray,
                          font: .systemFont(ofSize: 13), numberOfLines: 2)
        mallNameLabel.design(font: .systemFont(ofSize: 14, weight: .semibold))
        lpriceLabel.design(font: .boldSystemFont(ofSize: 16))
    }
    
    func configureLayout() {
        productImageView.snp.makeConstraints { make in
            make.horizontalEdges.top.equalToSuperview()
            make.height.equalTo(productImageView.snp.width)
        }
        
        likeButton.snp.makeConstraints { make in
            make.bottom.trailing.equalTo(productImageView).inset(10)
            make.size.equalTo(28)
        }
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalTo(productImageView.snp.bottom).offset(6)
            make.horizontalEdges.equalToSuperview().inset(4)
            make.height.greaterThanOrEqualTo(36)
        }
        
        mallNameLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).offset(4)
            make.horizontalEdges.equalTo(titleLabel)
        }
        
        lpriceLabel.snp.makeConstraints { make in
            make.top.equalTo(mallNameLabel.snp.bottom).offset(6)
            make.horizontalEdges.equalTo(titleLabel)
            make.bottom.greaterThanOrEqualTo(contentView).inset(16)
        }
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
