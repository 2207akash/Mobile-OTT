//
//  HomeFeaturedPagerViewCell.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit

class HomeFeaturedPagerViewCell: FSPagerViewCell {

    @IBOutlet weak var thumbImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundCorners(corners: [.allCorners], radius: 12)
    }

}
