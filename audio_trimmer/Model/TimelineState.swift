//
//  TimelineState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct ProgrammaticScrollProgress: Equatable {
    var value: Double?
    
    func isValid() -> Bool {
        if let value = value, (0...1).contains(value) {
            return true
        }
        return false
    }
    
    mutating func setInvalid() {
        value = nil
    }
}

struct TimelineInfoState {
    var trackDuration: Int
    var playbackTime: Double
    var trimmedDuration: Double
    
    func copyWith(
        trackDuration: Int? = nil,
        playbackTime: Double? = nil,
        trimmedDuration: Double? = nil
    ) -> TimelineInfoState {
        return TimelineInfoState(
            trackDuration: trackDuration ?? self.trackDuration,
            playbackTime: playbackTime ?? self.playbackTime,
            trimmedDuration: trimmedDuration ?? self.trimmedDuration
        )
    }
    
    private var validDisplayingPlaybackTime: Double {
        let upperBound = Double(trackDuration) - trimmedDuration
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
    
    static let `default` = TimelineInfoState(trackDuration: 0, playbackTime: 0, trimmedDuration: 0)
}

struct TimelineProgressState {
    var trimmedDuration: Double
    var trimmedDurationRatio: Double
    var programmaticScrollProgress: ProgrammaticScrollProgress
    
    func copyWith(
        trimmedDuration: Double? = nil,
        trimmedDurationRatio: Double? = nil,
        programmaticScrollProgress: ProgrammaticScrollProgress? = nil
    ) -> TimelineProgressState {
        return TimelineProgressState(
            trimmedDuration: trimmedDuration ?? self.trimmedDuration,
            trimmedDurationRatio: trimmedDurationRatio ?? self.trimmedDurationRatio,
            programmaticScrollProgress: programmaticScrollProgress ?? self.programmaticScrollProgress
        )
    }
    
    static let `default` = TimelineProgressState(trimmedDuration: 0, trimmedDurationRatio: 0, programmaticScrollProgress: ProgrammaticScrollProgress(value: 0))
}
