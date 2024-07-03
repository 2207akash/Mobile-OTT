//
//  MovieTagCell.swift
//  OTT
//
//  Created by Akash Sen on 02/07/24.
//

import UIKit

class MovieTagCell: UICollectionViewCell {

    // MARK: IBOutlets
    @IBOutlet weak var tagLabel: UILabel!
    
    
    // MARK: Cell Lifecycle
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.applyBorder(width: 1.5, color: UIColor(named: "SubTextColor") ?? .gray)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        self.roundCorners(corners: .allCorners, radius: self.frame.size.height/2)
    }

}
