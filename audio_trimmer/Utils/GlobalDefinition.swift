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
        return self.formatted(.percent.precision(.fractionLength(1)))        
    }
    
    func clamped() -> Double {
        guard isFinite else { return 0 }
        return min(max(self, 0), 1)
    }
}

typealias onUserSeekToProgressCallback = (_ progress: Double) -> Void

let TrackLengthOptions: [Int] = [10, 20, 30, 40, 50, 60]

let KeyTimeOptions: [Double] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

let TimelineLengthRatioOptions: [Double] = [0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, 1.0]

let WaveSamples: [Double] = Array(repeating: [0.2, 0.5, 0.9, 0.4, 0.7, 0.3, 0.8], count: 50).flatMap { $0 }

enum Screen: Hashable {
    case AudioTrimmerScreen(config: AppConfig)
}
