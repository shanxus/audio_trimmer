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
    
    func copyWith(
        timelineConfig: TimelineConfig? = nil,
        programmaticScrollProgress: Double? = nil,
        playbackTime: Double? = nil,
        trimmedDuration: Double? = nil
    ) -> TimelineViewState {
        return TimelineViewState(
            timelineConfig: timelineConfig ?? self.timelineConfig,
            programmaticScrollProgress: programmaticScrollProgress ?? self.programmaticScrollProgress,
            playbackTime: playbackTime ?? self.playbackTime,
            trimmedDuration: trimmedDuration ?? self.trimmedDuration
        )
    }
    
    private var validDisplayingPlaybackTime: Double {
        let upperBound = Double(timelineConfig.trackDuration) - trimmedDuration
        let lowerBound: Double = 0
        
        let clampedValue = min(max(playbackTime, lowerBound), upperBound)
        return clampedValue
    }
    
    var currentPlaybackTimeLabelValue: String {
        return validDisplayingPlaybackTime.mmss
    }
    
    var selectedStartTimeLabelValue: String {
        return validDisplayingPlaybackTime.mmss
    }
    
    var selectedEndTimeLabelValue: String {
        return (validDisplayingPlaybackTime + trimmedDuration).mmss
    }
    
    static let `default` = TimelineViewState(timelineConfig: .default, programmaticScrollProgress: 0)
}
