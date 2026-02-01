//
//  TimelineState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct ProgrammaticScrollProgress: Equatable {
    var value: Double
    
    var isValid: Bool {
        return value >= 0 && value <= 1
    }
    
    static let `default` = ProgrammaticScrollProgress(value: 0)
}

struct TimelineConfig {
    var trimmedDurationRatio: Double
    
    static let `default` = TimelineConfig(trimmedDurationRatio: 0)
}

struct TimelineViewState {
    var timelineConfig: TimelineConfig
    var programmaticScrollProgress: ProgrammaticScrollProgress
    
    var playbackTime: Double = 0
    var trimmedDuration: Double = 0
    
    let waveSamples: [Double] = Array(repeating: [0.2, 0.5, 0.9, 0.4, 0.7, 0.3, 0.8], count: 50).flatMap { $0 }
    
    var currentPlaybackTimeInMMSS: String {
        return playbackTime.mmss
    }
    
    var selectedEndTimeInMMSS: String {
        return (playbackTime + trimmedDuration).mmss
    }
    
    static let `default` = TimelineViewState(timelineConfig: .default, programmaticScrollProgress: .default)
}
