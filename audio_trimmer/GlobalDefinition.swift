//
//  GlobalDefinition.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/31.
//

import SwiftUI

extension Color {    
    static let darkGrey: Color = .black.opacity(0.8)
}

extension Double {
    var mmss: String {
        let total = Int(self.rounded())
        return String(format: "%d:%02d", total / 60, total % 60)
    }
    
    var formattedProgress: String {
        return String(format: "%.1f", self)
    }
}

typealias onUserSeekToProgressCallback = (_ progress: Double) -> Void
