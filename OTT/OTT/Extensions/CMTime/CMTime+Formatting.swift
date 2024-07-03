//
//  CMTime+Formatting.swift
//  OTT
//
//  Created by Akash Sen on 01/07/24.
//

import AVFoundation

extension CMTime {
    func formattedTime() -> String {
        let totalSeconds = CMTimeGetSeconds(self)
        guard !totalSeconds.isNaN else { return "0s" }

        let hours = Int(totalSeconds) / 3600
        let minutes = (Int(totalSeconds) % 3600) / 60
        let seconds = Int(totalSeconds) % 60

        var formattedString = ""
        if hours > 0 {
            formattedString += "\(hours)hr "
        }
        if minutes > 0 {
            formattedString += "\(minutes)m "
        }
        formattedString += "\(seconds)s"

        return formattedString.trimmingCharacters(in: .whitespaces)
    }
}
