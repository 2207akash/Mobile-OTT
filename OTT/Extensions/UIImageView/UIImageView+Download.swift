//
//  UIImageView+Download.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit

extension UIImageView {
    
    func loadImage(from urlString: String, placeholder: UIImage? = nil) {
        self.image = placeholder
        
        // Check cache for image first
        if let cachedImage = ImageCache.shared.object(forKey: NSString(string: urlString)) {
            self.image = cachedImage
            return
        }
        
        // Otherwise, download image from URL
        guard let url = URL(string: urlString) else {
            print("Invalid URL.")
            return
        }
        
        let task = URLSession.shared.dataTask(with: url) { [weak self] data, response, error in
            guard let self = self else { return }
            
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
                return
            }
            
            guard let data = data, let downloadedImage = UIImage(data: data) else {
                print("No data or unable to convert data to UIImage.")
                return
            }
            
            // Cache the image
            ImageCache.shared.setObject(downloadedImage, forKey: NSString(string: urlString))
            
            DispatchQueue.main.async {
                self.image = downloadedImage
            }
        }
        task.resume()
    }
    
}
