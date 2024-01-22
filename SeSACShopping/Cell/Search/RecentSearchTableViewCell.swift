//
//  RecentSearchTableViewCell.swift
//  SeSACShopping
//
//  Created by 조유진 on 1/22/24.
//

import UIKit

class RecentSearchTableViewCell: UITableViewCell, CellProtocol {
    
    
    @IBOutlet weak var searchImageView: UIImageView!
    @IBOutlet weak var searchKeywordLabel: UILabel!
    @IBOutlet weak var removeButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = ColorStyle.backgroundColor
        searchImageView.design(image: ImageStyle.search, tintColor: ColorStyle.textColor, contentMode: .scaleAspectFit)
        searchKeywordLabel.design(font: .systemFont(ofSize: 14))
        removeButton.design(image: ImageStyle.xmark, tintColor: .gray, backgroundColor: .clear)
        
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func configureCell(item: Any) {
        let keyword = item as! String
        searchKeywordLabel.text = keyword
    }
}
