//
//  VideoPlayerDelegate.swift
//  OTT
//
//  Created by Akash Sen on 03/07/24.
//

import Foundation

protocol VideoPlayerDelegate: NSObject {
    func playPreviousVideoTapped()
    func playNextVideoTapped()
}
