//
//  ImageCache.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit

class ImageCache {
    static let shared = NSCache<NSString, UIImage>()
    
    private init() {}
}
