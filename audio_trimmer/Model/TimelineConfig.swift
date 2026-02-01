//
//  TimelineConfig.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct TimelineConfig {
    var trimmedDurationRatio: Double
    var trackDuration: Int
    
    static let `default` = TimelineConfig(trimmedDurationRatio: 0, trackDuration: 0)
}
