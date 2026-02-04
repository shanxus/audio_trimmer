//
//  AudioServiceState.swift
//  audio_trimmer
//
//  Created by Shan OvO on 2026/1/29.
//

enum PlaybackTimeUpdateAction {
    case playback
    case seek
}

struct AudioServiceState: Equatable {
    var currentPlaybackTime: Double
    var isPlaying: Bool
    var playbackTimeUpdateAction: PlaybackTimeUpdateAction?
    var seekActionSource: SeekActionSource?
    
    static let initial: AudioServiceState = .init(currentPlaybackTime: 0, isPlaying: false)
    
    func copyWith(
        currentPlaybackTime: Double? = nil,
        isPlaying: Bool? = nil,
        playbackTimeUpdateAction: PlaybackTimeUpdateAction? = nil,
        seekActionSource: SeekActionSource? = nil
    ) -> AudioServiceState {
        return .init(
            currentPlaybackTime: currentPlaybackTime ?? self.currentPlaybackTime,
            isPlaying: isPlaying ?? self.isPlaying,
            playbackTimeUpdateAction: playbackTimeUpdateAction ?? self.playbackTimeUpdateAction,
            seekActionSource: seekActionSource ?? self.seekActionSource
        )
    }
}
