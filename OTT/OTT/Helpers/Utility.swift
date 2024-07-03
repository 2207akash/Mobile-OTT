//
//  Utility.swift
//  OTT
//
//  Created by Akash Sen on 29/06/24.
//

import UIKit

class Utility {
    private init() {}
}


// MARK: Alerts & Sheets
extension Utility {
    
    static func showAlert(on vc: UIViewController,
                          title: String,
                          message: String,
                          options: [String],
                          completion: ((Int) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        
        for (index, option) in options.enumerated() {
            let action = UIAlertAction(title: option, style: .default) { _ in
                completion?(index)
            }
            alert.addAction(action)
        }

        vc.present(alert, animated: true, completion: nil)
    }
    
}


// MARK: Orientation Handling
extension Utility {
    
    static func lockOrientation(_ orientation: UIInterfaceOrientationMask) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = orientation
        }
    }

    static func lockOrientation(_ orientation: UIInterfaceOrientationMask, andRotateTo rotateOrientation:UIInterfaceOrientation) {
        self.lockOrientation(orientation)
    
        UIDevice.current.setValue(rotateOrientation.rawValue, forKey: "orientation")
        UINavigationController.attemptRotationToDeviceOrientation()
    }
    
}
