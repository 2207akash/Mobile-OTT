//
//  VideoPlayerDelegate.swift
//  OTT
//
//  Created by Akash Sen on 03/07/24.
//

import Foundation

enum VideoPlayerAction {
    case prevTapped
    case nextTapped
    case playTapped
    case pauseTapped
    case fullScreenTapped
}


protocol VideoPlayerDelegate {
    func playPreviousVideoTapped()
    func playNextVideoTapped()
}
