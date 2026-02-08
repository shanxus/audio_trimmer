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
    var playbackTime: Double
    var rangeStartTime: Double
    var rangeEndTime: Double
    
    func copyWith(
        playbackTime: Double? = nil,
        rangeStartTime: Double? = nil,
        rangeEndTime: Double? = nil
    ) -> TimelineInfoState {
        return TimelineInfoState(
            playbackTime: playbackTime ?? self.playbackTime,
            rangeStartTime: rangeStartTime ?? self.rangeStartTime,
            rangeEndTime: rangeEndTime ?? self.rangeEndTime
        )
    }
    
    var currentPlaybackTimeLabelValue: String {
        return playbackTime.mmss
    }
    
    var selectedStartTimeLabelValue: String {
        return rangeStartTime.mmss
    }
    
    var selectedEndTimeLabelValue: String {
        return rangeEndTime.mmss
    }
    
    static let `default` = TimelineInfoState(playbackTime: 0, rangeStartTime: 0, rangeEndTime: 0)
}

struct TimelineProgressState {
    var trimmedDuration: Double
    var trimmedDurationRatio: Double
    var programmaticScrollProgress: ProgrammaticScrollProgress
    var playbackProgressInRange: Double
    
    func copyWith(
        trimmedDuration: Double? = nil,
        trimmedDurationRatio: Double? = nil,
        programmaticScrollProgress: ProgrammaticScrollProgress? = nil,
        playbackProgressInRange: Double? = nil,
    ) -> TimelineProgressState {
        return TimelineProgressState(
            trimmedDuration: trimmedDuration ?? self.trimmedDuration,
            trimmedDurationRatio: trimmedDurationRatio ?? self.trimmedDurationRatio,
            programmaticScrollProgress: programmaticScrollProgress ?? self.programmaticScrollProgress,
            playbackProgressInRange: playbackProgressInRange ?? self.playbackProgressInRange
        )
    }
    
    static let `default` = TimelineProgressState(trimmedDuration: 0, trimmedDurationRatio: 0, programmaticScrollProgress: ProgrammaticScrollProgress(value: 0), playbackProgressInRange: 0)
}
