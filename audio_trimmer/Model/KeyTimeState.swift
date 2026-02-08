//
//  KeyTimeSelectionState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct KeyTimeInfoState {
    var playbackProgressRatio: Double
    var rangeStartRatio: Double
    var rangeEndRatio: Double
    
    func copyWith(
        playbackProgressRatio: Double? = nil,
        rangeStartRatio: Double? = nil,
        rangeEndRatio: Double? = nil
    ) -> KeyTimeInfoState {
            return KeyTimeInfoState(
                playbackProgressRatio: playbackProgressRatio ?? self.playbackProgressRatio,
                rangeStartRatio: rangeStartRatio ?? self.rangeStartRatio,
                rangeEndRatio: rangeEndRatio ?? self.rangeEndRatio
            )
        }
    
    var currentPlaybackProgressLabelValue: String {
        return playbackProgressRatio.formattedProgress
    }
    
    var selectedStartTimeProgressLabelValue: String {
        return rangeStartRatio.formattedProgress
    }
    
    var selectedEndTimeProgressLabelValue: String {
        return rangeEndRatio.formattedProgress
    }
    
    static let `default` = KeyTimeInfoState(playbackProgressRatio: 0, rangeStartRatio: 0, rangeEndRatio: 0)
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
