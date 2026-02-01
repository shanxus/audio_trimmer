//
//  KeyTimeSelectionState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/2/1.
//

struct KeyTimeSelectionState {
    var keyTimes: [Double]
    var trimmedRatio: Double
    var playbackProgress: Double
    
    var currentPlaybackProgress: String {
        return playbackProgress.formattedProgress
    }
    
    var selectedEndTimeProgress: String {
        return (playbackProgress + trimmedRatio).formattedProgress        
    }
    
    static let `default` = KeyTimeSelectionState(keyTimes: [], trimmedRatio: 0, playbackProgress: 0)
}
