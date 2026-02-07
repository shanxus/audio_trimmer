//
//  KeyTimeSelectionState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct KeyTimeInfoState {
    var trimmedRatio: Double
    var playbackProgressRatio: Double
    
    func copyWith(
        trimmedRatio: Double? = nil,
        playbackProgressRatio: Double? = nil) -> KeyTimeInfoState {
            return KeyTimeInfoState(
                trimmedRatio: trimmedRatio ?? self.trimmedRatio,
                playbackProgressRatio: playbackProgressRatio ?? self.playbackProgressRatio)
        }
    
    private var validDisplayingPlaybackProgress: Double {
        let upperBound: Double = 1 - trimmedRatio
        let lowerBound: Double = 0
        return min(max(playbackProgressRatio, lowerBound), upperBound)
    }
    
    var currentPlaybackProgressLabelValue: String {
        return validDisplayingPlaybackProgress.formattedProgress
    }
    
    var selectedStartTimeProgressLabelValue: String {
        return validDisplayingPlaybackProgress.formattedProgress
    }
    
    var selectedEndTimeProgressLabelValue: String {
        return (validDisplayingPlaybackProgress + trimmedRatio).formattedProgress
    }
    
    static let `default` = KeyTimeInfoState(trimmedRatio: 0, playbackProgressRatio: 0)
}

struct KeyTimeProgressState {
    var keyTimes: [Double]
    var trimmedRatio: Double
    var playbackProgressRatio: Double
    
    func copyWith(
        keyTimes: [Double]? = nil,
        trimmedRatio: Double? = nil,
        playbackProgressRatio: Double? = nil) -> KeyTimeProgressState {
            return KeyTimeProgressState(
                keyTimes: keyTimes ?? self.keyTimes,
                trimmedRatio: trimmedRatio ?? self.trimmedRatio,
                playbackProgressRatio: playbackProgressRatio ?? self.playbackProgressRatio)
    }
    
    static let `default` = KeyTimeProgressState(keyTimes: [], trimmedRatio: 0, playbackProgressRatio: 0)
}

struct KeyTimeState {
    var infoState: KeyTimeInfoState
    var progressState: KeyTimeProgressState
}
