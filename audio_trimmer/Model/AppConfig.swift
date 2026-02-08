//
//  AppConfig.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct AppConfig: Hashable {
    var trackLength: Int
    var keyTimes: [Double]
    var trimmedRangeRatio: Double
    
    var trimmedDuration: Double {
        return trimmedRangeRatio * Double(trackLength)
    }
    
    static let `default` = AppConfig(trackLength: 15, keyTimes: [0, 0.5, 0.75, 1], trimmedRangeRatio: 0.1)
}
