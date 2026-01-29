//
//  AudioServiceState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/29.
//

struct AudioServiceState: Equatable {
    var currentPlaybackTime: Double
    var isPlaying: Bool
    
    static let initial: AudioServiceState = .init(currentPlaybackTime: 0, isPlaying: false)
}
