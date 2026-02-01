//
//  TimelineState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct TimelineViewState {
    var timelineConfig: TimelineConfig
    var programmaticScrollProgress: Double
    
    var playbackTime: Double = 0
    var trimmedDuration: Double = 0
    
    let waveSamples: [Double] = Array(repeating: [0.2, 0.5, 0.9, 0.4, 0.7, 0.3, 0.8], count: 50).flatMap { $0 }
    
    var currentPlaybackTimeInMMSS: String {
        return playbackTime.mmss
    }
    
    var selectedEndTimeInMMSS: String {
        return (playbackTime + trimmedDuration).mmss
    }
    
    static let `default` = TimelineViewState(timelineConfig: .default, programmaticScrollProgress: 0)
}
