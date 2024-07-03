//
//  HomeVideoThumbCollectionViewCell.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit

class HomeVideoThumbCollectionViewCell: UICollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var thumbImageView: UIImageView!
    
    // MARK: Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.roundCorners(corners: [.allCorners], radius: 12)
    }

}
