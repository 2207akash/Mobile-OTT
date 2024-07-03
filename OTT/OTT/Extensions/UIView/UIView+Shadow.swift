//
//  Constants.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//


import Foundation
import UIKit

extension UIView {
    
    enum ShadowType {
        case dropShadow
        case deepShadow
        case allSides
        case top
    }
    
    func applyShadow(shadowType: ShadowType, shadowColor: UIColor) {
        self.layer.shadowColor = shadowColor.cgColor
        self.layer.masksToBounds = false
        
        if(shadowType == .deepShadow) {
            self.layer.borderWidth = 0.4
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 1, height: 4)
        } else if(shadowType == .dropShadow) {
            self.layer.shadowRadius = 4
            self.layer.shadowOpacity = 0.5
            self.layer.shadowOffset = CGSize(width: 1, height: 4)
        } else if(shadowType == .allSides) {
            self.layer.shadowRadius = 5
            self.layer.shadowOpacity = 0.4
            self.layer.shadowOffset = CGSize(width: -0.3, height: 2)
        } else if(shadowType == .top) {
            self.layer.shadowRadius = 3
            self.layer.shadowOpacity = 0.75
            self.layer.shadowOffset = CGSize(width: 0, height: -0.5)
        }
    }
    
    func applyBorder(width: CGFloat, color: UIColor) {
        self.layer.borderWidth = width
        self.layer.borderColor = color.cgColor
    }

    func roundCorners(corners: UIRectCorner, radius: CGFloat) {
        self.clipsToBounds = true
        self.layer.cornerRadius = radius
        
        var masked = CACornerMask()
        if corners.contains(.topLeft) { masked.insert(.layerMinXMinYCorner) }
        if corners.contains(.topRight) { masked.insert(.layerMaxXMinYCorner) }
        if corners.contains(.bottomLeft) { masked.insert(.layerMinXMaxYCorner) }
        if corners.contains(.bottomRight) { masked.insert(.layerMaxXMaxYCorner) }
        self.layer.maskedCorners = masked
    }
    
}
