//
//  KeyTimeSelectionState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct KeyTimeSelectionState {
    var keyTimes: [Double]
    var trimmedRatio: Double
    var playbackProgressRatio: Double
    
    func copyWith(
        keyTimes: [Double]? = nil,
        trimmedRatio: Double? = nil,
        playbackProgressRatio: Double? = nil) -> KeyTimeSelectionState {
            return KeyTimeSelectionState(
                keyTimes: keyTimes ?? self.keyTimes,
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
    
    static let `default` = KeyTimeSelectionState(keyTimes: [], trimmedRatio: 0, playbackProgressRatio: 0)
}
