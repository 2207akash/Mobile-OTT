//
//  AVURLAsset+Extension.swift
//  OTT
//
//  Created by Akash Sen on 01/07/24.
//

import AVFoundation

extension AVURLAsset {
    
    func loadDuration(completion: @escaping (String?) -> Void) {
        self.loadValuesAsynchronously(forKeys: ["duration"]) {
            var error: NSError? = nil
            let status = self.statusOfValue(forKey: "duration", error: &error)
            switch status {
            case .loaded:
                let duration = self.duration.formattedTimeForVideoDetailPage()
                DispatchQueue.main.async {
                    completion(duration)
                }
            case .failed, .cancelled, .unknown:
                DispatchQueue.main.async {
                    completion(nil)
                }
            case .loading:
                DispatchQueue.main.async {
                    completion(nil)
                }
            @unknown default:
                DispatchQueue.main.async {
                    completion(nil)
                }
            }
        }
    }
    
}
